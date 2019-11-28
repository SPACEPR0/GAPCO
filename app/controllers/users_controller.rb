class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  layout "areas_layout"
  def index
    @users  = User.all
  end

  def show
  end

  def edit
  end

  def update
    if (current_user.role == 0) then
      respond_to do |format|

        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'El usuario ha sido actualizado exitosamente.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end


  def new
      @user=User.new
  end

  def create
    if (current_user.role == 0) then
      @user = User.new(user_params)

      respond_to do |format|
        if @user.save
          #redirect_to root_path
          format.html { redirect_to @user, notice: 'El usuario ha sido creada exitosamente.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  def destroy
    @user.areas.each do |area|
      area.update(user_id: current_user.id)
    end
    if (current_user.role == 0) then
      Notification.where(notifiable: @user).each do |notification|
        notification.destroy
      end
      Notification.where(actor: @user).each do |notification|
        notification.destroy
      end
      @user.destroy

      respond_to do |format|
        format.html { redirect_to :index, notice: 'El usuario se ha eliminado exitosamente.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :role, :area_ids => [])
  end

  def set_user
    @user = User.find(params[:id])
  end

end
