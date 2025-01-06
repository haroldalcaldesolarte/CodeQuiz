class GameSessionsController < ApplicationController
  before_action :set_game_session, only: %i[ destroy ]

  # GET /game_sessions or /game_sessions.json
  def index
    #@categories = Category.all #Dependiendo del curso del alumno deben salir sus categorias(asignaturas)
    categories_course = CategoriesCourse.where(course_id: current_user.course_id)
    @categories = Category.where(id: categories_course.pluck(:category_id))
    @levels = Level.all
  end

  # POST /game_sessions or /game_sessions.json
  def create
    @category = Category.find(params[:category_id])
    @level = Level.find(params[:level_id])

    #Controlar que si no hay 10 preguntas no se puede empezar la partida
    if @level.name.include?('mix')
      @questions = Question.where(category: @category, approved: true).shuffle.take(3)
    else
      @questions = Question.where(category: @category, level: @level, approved: true).shuffle.take(3)
    end

    @game_session = GameSession.create(user: current_user, category: @category, score: 0)

    session[:game_session_id] = @game_session.id
    session[:question_ids] = @questions.map(&:id)
    session[:current_question_index] = 0

    redirect_to play_game_sessions_path
  end

  def play
    @game_session = GameSession.find(session[:game_session_id])
    current_index = session[:current_question_index]
    question_ids = session[:question_ids]

    if current_index < question_ids.size
      @question = Question.find(question_ids[current_index])
      @categoy_name = @question.category.name
    else
      redirect_to result_game_sessions_path
    end
  end

  def answer
    game_session = GameSession.find(session[:game_session_id])
    question = Question.find(params[:question_id])
    user_answer = Answer.find(params[:answer_id])

    correct = user_answer.correct
    GameResponse.create(game_session: game_session, question: question, correct: correct)

    game_session.increment!(:score, 10) if correct
    session[:current_question_index] += 1

    render json: {
      correct: correct,
      next_question_index: session[:current_question_index] < session[:question_ids].size,
      question_path: play_game_sessions_path
    }
  end

  def result
    @game_session = GameSession.find(session[:game_session_id])
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
    @game_session.destroy

    respond_to do |format|
      format.html { redirect_to game_sessions_path, status: :see_other, notice: "Game session was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_session
      @game_session = GameSession.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_session_params
      params.require(:game_session).permit(:user_id, :category_id, :score, :level_id)
    end
end
