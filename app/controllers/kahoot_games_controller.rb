class KahootGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permissions, only: %i[new start create]
  before_action :set_kahoot_game, only: %i[show start destroy submit_answer next_question]
  before_action :check_participants, only: %i[show]

  def new
    @kahoot_game = KahootGame.new
    @levels = Level.all
    case current_user.role.name
    when 'teacher'
      categories_course = CategoriesCourse.where(course_id: current_user.course_id)
      @categories = Category.where(id: categories_course.pluck(:category_id))
    when 'admin'
      @categories = Category.all
    end
  end

  def create
    @kahoot_game = KahootGame.new(kahoot_game_params)
    @kahoot_game.host = current_user

    if KahootGame.can_add_questions?(kahoot_game_params[:category_id], kahoot_game_params[:level_id])
      if @kahoot_game.save
        @kahoot_game.add_questions
        redirect_to @kahoot_game, notice: 'Kahoot creado correctamente.'
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_kahoot_game_path, alert: "No se ha podido crear el Kahoot. No hay suficientes preguntas disponibles en esta categoría y nivel."
    end
  end

  def show
    @participants = @kahoot_game.kahoot_participants
  end

  def start
    if @kahoot_game.host == current_user
      @kahoot_game.update(status: :in_progress)

      @kahoot_game.current_question.update(sent_at: Time.current)

      KahootGameChannel.broadcast_to(@kahoot_game, { type: "game_started" })
      redirect_to @kahoot_game
    else
      redirect_to @kahoot_game, alert: "No tienes permisos para iniciar esta partida."
    end
  end

  def submit_answer
    participant = @kahoot_game.kahoot_participants.find_by(user: current_user)
    host = @kahoot_game.host

    unless participant
      return render json: {type: "", status: "error" ,message: "No estás en la partida"}, status: :forbidden
    end

    kahoot_question = @kahoot_game.current_question
    unless kahoot_question
      return render json: { error: "La pregunta no está en la partida." }, status: :unprocessable_entity
    end

    if KahootResponse.exists?(kahoot_participant: participant, kahoot_question: kahoot_question)
      return render json: { error: "Ya has respondido a esta pregunta." }, status: :unprocessable_entity
    end

    question = kahoot_question.question
    selected_answer = question.answers.find_by(id: params[:answer_id])
    
    unless selected_answer
      return render json: { error: "Respuesta no válida." }, status: :unprocessable_entity
    end

    correct = selected_answer.correct
    answered_at = Time.current
    score = correct ? calculate_score(answered_at, kahoot_question.sent_at) : 0
    
    KahootResponse.create!(
      kahoot_participant: participant,
      kahoot_question: kahoot_question,
      answered_at: answered_at,
      correct: correct,
      score: score
    )

    participant.update(score: participant.score + score)

    total_responses = kahoot_question.kahoot_responses.count

    KahootGameChannel.broadcast_to(participant, {
      type: "answer_feedback",
      correct: correct,
      question_score: score,
      total_score: participant.score
    })

    KahootGameChannel.broadcast_to(host, {
      type: "update_counter",
      count: total_responses
    })

    head :ok
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end
  
  def next_question
    return head :forbidden unless current_user == @kahoot_game.host

    if @kahoot_game.has_next_question?
      @kahoot_game.advance_question
      send_question
    else
      @kahoot_game.update(status: :finished)
      if @kahoot_game.finished?
        ranking = @kahoot_game.ranking
        KahootGameChannel.broadcast_to(@kahoot_game, { type: "game_finished", ranking: ranking })
      end
      
    end
  end

  def history
    @participation = KahootParticipant.where(user_id: current_user.id).order(created_at: :desc )
  end

  def destroy
    if @kahoot_game.host == current_user
      participants = @kahoot_game.kahoot_participants
      participants.each do |participant|
        KahootGameChannel.broadcast_to(participant, { type: "game_canceled" })
      end
      @kahoot_game.destroy
      redirect_to new_kahoot_game_path, notice: "Partida eliminada."
    else
      redirect_to @kahoot_game, alert: "No puedes eliminar esta partida."
    end
  end

  private
  def calculate_score(answered_at, sent_at)
    max_score = 1000
    penalty_per_second = 20

    return if answered_at.nil?

    sent_time = sent_at
    return if sent_time.nil?

    response_time = (answered_at - sent_time).to_i
    [max_score - (response_time * penalty_per_second), 0].max
  end

  def set_kahoot_game
    @kahoot_game = KahootGame.find(params[:id])
  end

  def kahoot_game_params
    params.require(:kahoot_game).permit(:category_id, :level_id)
  end

  def check_permissions
    unless current_user.superuser?
      redirect_to authenticated_root_path, alert: "No tienes permiso para crear una partida kahoot."
    end
  end

  def check_participants
    if current_user.id != @kahoot_game.host.id
      unless @kahoot_game.kahoot_participants.collect(&:user_id).include?(current_user.id)
        redirect_to new_kahoot_participant_path, alert: "Debes unirte a la partida primero."
      end
    end
  end

  def send_question
    host = @kahoot_game.host
    participants = @kahoot_game.kahoot_participants
    kahoot_question = @kahoot_game.current_question
    question = kahoot_question.question
    if question
      kahoot_question.update(sent_at: Time.current)

      participants.each do |participant|
        KahootGameChannel.broadcast_to(participant, {
          type: "new_question",
          host: "false",
          index_question: @kahoot_game.current_question_index + 1,
          question: {
            id: question.id,
            text: question.question_text,
            answers: question.answers.order(:id).map { |answer| { id: answer.id, answer_text: answer.answer_text } },
          } 
        })
      end

      KahootGameChannel.broadcast_to(host, {
        type: "new_question",
        host: "true",
        index_question: @kahoot_game.current_question_index + 1,
        question: {
          id: question.id,
          text: question.question_text,
          answers: question.answers.order(:id).map { |answer| { id: answer.id, answer_text: answer.answer_text } },
        } 
      })

      KahootGameChannel.broadcast_to(host, {
        type: "update_counter",
        count: 0
      })

      head :ok
    end
  end
end
