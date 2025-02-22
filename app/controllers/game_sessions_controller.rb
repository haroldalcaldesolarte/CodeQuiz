class GameSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game_session, only: %i[play answer result destroy]
  before_action :check_game_session_finished, only: :result

  NUMBER_OF_QUESTIONS_PER_GAME = 3

  # GET /game_sessions or /game_sessions.json
  def index
    @levels = Level.all
    case current_user.role.name
    when 'student', 'teacher'
      categories_course = CategoriesCourse.where(course_id: current_user.course_id)
      @categories = Category.where(id: categories_course.pluck(:category_id))
    when 'admin'
      @categories = Category.all
    end
  end
  
  def history
    @game_sessions = current_user.game_sessions.order(created_at: :desc) 
  end

  def show
    @game_session = current_user.game_sessions.find(params[:id])
    @game_responses = @game_session.game_responses.includes(:question)
  end

  # POST /game_sessions or /game_sessions.json
  def create
    @category = Category.find(params[:category_id])
    @level = Level.find(params[:level_id])

    if @level.name.include?('mix')
      @questions = Question.where(category: @category, status: 1).order(Arel.sql("RANDOM()")).limit(NUMBER_OF_QUESTIONS_PER_GAME)
    else
      @questions = Question.where(category: @category, level: @level, status: 1).order(Arel.sql("RANDOM()")).limit(NUMBER_OF_QUESTIONS_PER_GAME)
    end

    if @questions.empty?
      redirect_to game_sessions_path, alert: "No hay preguntas disponibles para esta categoría y nivel."
      return
    end

    @game_session = GameSession.create(user: current_user, category: @category, level: @level, score: 0)

    session[:game_session_id] = @game_session.id
    session[:question_ids] = @questions.map(&:id)
    session[:current_question_index] = 0

    redirect_to play_game_session_path(@game_session)
  end

  def play
    @level = @game_session.level
    @category_name = @game_session.category.name
    current_index = session[:current_question_index]
    question_ids = session[:question_ids]

    if current_index < question_ids.size
      @question = Question.find(question_ids[current_index])
    end
  end

  def answer
    question = Question.find(params[:question_id])
    user_answer = Answer.find(params[:answer_id])

    correct = user_answer.correct
    GameResponse.create(game_session: @game_session, question: question, correct: correct)

    @game_session.increment!(:score, 10) if correct
    session[:current_question_index] += 1

    if session[:current_question_index] >= session[:question_ids].size
      @game_session.update!(status: :finished)
    end

    render json: {
      correct: correct,
      next_question_index: session[:current_question_index] < session[:question_ids].size,
      question_path: play_game_session_path(@game_session),
      result_path: result_game_session_path(@game_session)
    }
  end

  def result
    @responses = @game_session.game_responses.includes(:question)
  end

  # PATCH/PUT /game_sessions/1 or /game_sessions/1.json
  def update
    respond_to do |format|
      if @game_session.update(game_session_params)
        format.html { redirect_to @game_session, notice: "Game session was successfully updated." }
        format.json { render :show, status: :ok, location: @game_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_sessions/1 or /game_sessions/1.json
  def destroy
    if current_user == @game_session.user
      @game_session.destroy

      respond_to do |format|
        format.html { redirect_to game_sessions_path, status: :see_other, notice: "Partida cancelada." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_session
      @game_session = GameSession.find_by(id: params[:id], user: current_user)

      if @game_session.nil? || @game_session.id != session[:game_session_id]
        redirect_to game_sessions_path, alert: "No tienes acceso a esta partida o no es la partida activa."
      end
    end

    # Only allow a list of trusted parameters through.
    def game_session_params
      params.require(:game_session).permit(:category_id, :level_id)
    end

    def check_game_session_finished
      unless @game_session.finished?
        redirect_to play_game_session_path(@game_session), alert: "La partida no ha terminado aún."
      end
    end
end
