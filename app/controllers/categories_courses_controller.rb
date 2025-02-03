class CategoriesCoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permissions
  before_action :set_categories_course, only: %i[ show edit update destroy ]
  before_action :set_init_variables, only: %i[ new edit update create]

  # GET /categories_courses or /categories_courses.json
  def index
    @categories_courses = CategoriesCourse.all
  end

  # GET /categories_courses/1 or /categories_courses/1.json
  def show
  end

  # GET /categories_courses/new
  def new
    @categories_course = CategoriesCourse.new
  end

  # GET /categories_courses/1/edit
  def edit
  end

  # POST /categories_courses or /categories_courses.json
  def create
    @categories_course = CategoriesCourse.new(categories_course_params)

    respond_to do |format|
      if @categories_course.save
        format.html { redirect_to @categories_course, notice: "Relación creada correctamente." }
        format.json { render :show, status: :created, location: @categories_course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @categories_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories_courses/1 or /categories_courses/1.json
  def update
    respond_to do |format|
      if @categories_course.update(categories_course_params)
        format.html { redirect_to @categories_course, notice: "Relación actualizada correctamente." }
        format.json { render :show, status: :ok, location: @categories_course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @categories_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories_courses/1 or /categories_courses/1.json
  def destroy
    @categories_course.destroy

    respond_to do |format|
      format.html { redirect_to categories_courses_path, status: :see_other, notice: "Relación eliminada correctamente." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_categories_course
      @categories_course = CategoriesCourse.find(params[:id])
      @course = @categories_course.course
      @category = @categories_course.category
    end

    def set_init_variables
      @categories = Category.all
      @courses = Course.all
    end

    # Only allow a list of trusted parameters through.
    def categories_course_params
      params.require(:categories_course).permit(:category_id, :course_id)
    end
    def check_permissions
      unless current_user.superuser?
        redirect_to authenticated_root_path, alert: "No tienes permiso para acceder a esta sección."
      end
    end
end
