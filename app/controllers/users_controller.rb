class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update]
  before_action :authorize_admin, only: [:index, :destroy]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      if current_user.admin?
        redirect_to users_path, notice: "Usuario actualizado correctamente."
      else
        redirect_to edit_user_path(current_user), notice: "Tu perfil se actualizó correctamente."
      end
    else
      render :edit, alert: "Hubo un error al actualizar el usuario."
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "Usuario eliminado correctamente."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :surname, :role_id, :course_id, :password, :password_confirmation)
  end

  def authorize_user
    unless current_user.admin? || current_user == @user
      redirect_to authenticated_root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end

  def authorize_admin
    unless current_user.admin?
      redirect_to authenticated_root_path, alert: "No tienes permiso para acceder a esta sección."
    end
  end
end
