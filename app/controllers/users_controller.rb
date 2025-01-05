class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :edit_password, :update_password, :destroy]
  before_action :authorize_user, only: [:edit, :update, :edit_password]
  before_action :authorize_admin, only: [:index, :destroy]

  def index
    @users = User.all
    @admins = User.where(role_id: Role.find_by(name: 'admin'))
    @teachers = User.where(role_id: Role.find_by(name: 'teacher'))
    @students = User.where(role_id: Role.find_by(name: 'student'))
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: current_user == @user ? "Tu perfil se actualizó correctamente." : "El perfil se actualizó correctamente."
    else
      redirect_to edit_user_path(@user), alert: current_user == @user ? "Hubo un error al actualizar tu perfil. Vuelve a intentarlo." : "Hubo un error al actualizar el perfil. Vuelve a intentarlo."
    end
  end

  def edit_password
  end

  def update_password
    if current_user == @user 
      if @user.valid_password?(params[:user][:current_password]) #Se comprueba la contraseña actual antes de actualizar
        if @user.update(password_params)
          bypass_sign_in(@user)
          redirect_to edit_password_user_path(@user), notice: "Tu contraseña se actualizó correctamente."
        else
          redirect_to edit_password_user_path(@user), alert: "La nueva contraseña no es válida. Vuelve a intentarlo."
        end
      else
        redirect_to edit_password_user_path(@user), alert: "La contraseña actual no es correcta. Vuelve a intentarlo."
      end
    else #Es el admin quien esta actualizando la contraseña de otro usuario y no se pide la contraseña actual de la cuenta a actualizar
      if @user.update(password_params)
        bypass_sign_in(current_user)
        redirect_to edit_password_user_path(@user), notice: "La contraseña se actualizó correctamente."
      else
        redirect_to edit_password_user_path(@user), alert: "La nueva contraseña no es válida. Vuelve a intentarlo."
      end
    end
  end
  def destroy
    @user.destroy
    redirect_to users_path, notice: "Usuario eliminado correctamente."
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      if current_user.admin?
        redirect_to users_path, alert: "El usuario no existe o la URL es inválida."
      else
        redirect_to game_sessions_path, alert: "El usuario no existe o la URL es inválida."
      end
    end
  end

  def user_params
    params.require(:user).permit(:email, :name, :surname, :username, :role_id, :course_id)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
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
