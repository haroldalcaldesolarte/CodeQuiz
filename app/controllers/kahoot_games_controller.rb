class KahootGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permissions, only: %i[new start create]
  before_action :set_kahoot_game, only: %i[show start destroy]
  before_action :check_participants, only: [:show]

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

    if @kahoot_game.save
      redirect_to @kahoot_game
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @participants = @kahoot_game.kahoot_participants
  end

  def start
    if @kahoot_game.host == current_user
      @kahoot_game.update(status: :in_progress)
      redirect_to @kahoot_game, notice: "¡Partida iniciada!"
    else
      redirect_to @kahoot_game, alert: "No tienes permisos para iniciar esta partida."
    end
  end

  def destroy
    if @kahoot_game.host == current_user
      @kahoot_game.destroy
      redirect_to root_path, notice: "Partida eliminada."
    else
      redirect_to @kahoot_game, alert: "No puedes eliminar esta partida."
    end
  end

  private

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
end
