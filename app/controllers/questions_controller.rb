class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[ show edit update destroy review update_status]
  before_action :init_variables, only: %i[ new edit update create]

  NUMBER_OF_ANSWERS = 4
  # GET /questions or /questions.json
  def index
    @questions_created = Question.where(author_id: current_user.id).order(:id)
    @questions_reviewed = Question.where(revisor_id: current_user.id, status: [:approved, :rejected]).order(:id)
    @questions_pending_review =  Question.where(revisor_id: current_user.id, status: :pending).order(:id)
    case current_user.role.name
    when 'teacher'
      categories_course = CategoriesCourse.where(course_id: current_user.course_id)
      @questions_for_course = Question.where(category_id: categories_course.pluck(:category_id)).order(:id)
    when 'admin'
      @all_questions = Question.all.order(:id)
    end
  end

  # GET /questions/1 or /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    NUMBER_OF_ANSWERS.times { @question.answers.build }
  end

  # GET /questions/1/edit
  def edit
    unless @question.editable?(current_user)
      respond_to do |format|
        format.html { redirect_to @question, notice: "No tienes permiso para editar esta pregunta. Debes ser el autor de la pregunta" }
        format.json { render :show, status: :ok, location: @question }
      end
    end
  end

  # POST /questions or /questions.json
  def create
    @question = Question.new(question_params)
    @question.author = current_user
    #@question.status = nil if question_params[:approved] == "0" #Si no se marca el check de aprobado se envia un cero
    #En la creación de la pregunta pondremos aprobado a nil y esa sera nuestro estado de pendiente

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: "Pregunta creada correctamente." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: "Pregunta actualizada correctamente." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_path, status: :see_other, notice: "Pregunta eliminada correctamente." }
      format.json { head :no_content }
    end
  end

  def review
    unless @question.reviewable?(current_user)
      respond_to do |format|
        format.html { redirect_to @question, notice: "No tienes permiso para revisar esta pregunta." }
        format.json { render :show, status: :ok, location: @question }
      end
    end
  end

  def update_status
    unless @question.reviewable?(current_user)
      flash[:alert] = "No tienes permiso para modificar esta pregunta."
      return redirect_to questions_path
    end

    if params[:status] == "1"
      @question.update(status: :approved)
      flash[:notice] = "Pregunta aprobada correctamente."
    elsif params[:status] == "2"
      @question.update(status: :rejected)
      flash[:notice] = "Pregunta rechazada correctamente."
    else
      flash[:alert] = "Estado no válido."
    end

    redirect_to questions_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:question_text, :category_id, :level_id, :status, :author_id, :revisor_id,
      answers_attributes: [:id, :answer_text, :correct, :_destroy])
    end

    def init_variables
      case current_user.role.name
      when 'student', 'teacher'
        categories_course = CategoriesCourse.where(course_id: current_user.course_id)
        @categories = Category.where(id: categories_course.pluck(:category_id))
      when 'admin'
        @categories = Category.all
      end
      @categories_with_courses = @categories.map do |category|
        course_name = get_course_category(category.id)
        ["#{category.name} (#{course_name})", category.id]
      end
      @levels = Level.where.not(name: 'mix')
    end

    def get_course_category(category_id)
      course_category = CategoriesCourse.where(category_id: category_id)
      course = Course.where(id: course_category.first.course_id).first
      course.course_display_name
    end
end
