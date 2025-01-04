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
    if current_user == @user
      if @user.update_with_password(user_params)
        bypass_sign_in(@user) # Mantiene la sesión activa después de actualizar contraseña
        redirect_to edit_user_path(current_user), notice: "Tu perfil se actualizó correctamente."
      else
        redirect_to edit_user_path(current_user), alert: "Hubo un error al actualizar tu perfil. Vuelve a intentarlo."
      end
    else
      if @user.update(user_params.except(:current_password))
        redirect_to users_path, notice: "Usuario actualizado correctamente."
      else
        redirect_to edit_user_path(@user), alert: "Hubo un error al actualizar tu perfil. Vuelve a intentarlo."
      end
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
    params.require(:user).permit(:email, :name, :surname, :username, :role_id, :course_id, :password, :password_confirmation, :current_password)
  end

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def updating_password?
    params[:user][:password].present? || params[:user][:password_confirmation].present?
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
