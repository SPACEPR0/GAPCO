class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]    
  def index
    @users  = User.all
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'El usuario ha sido actualizado exitosamente.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def new
      @user=User.new
  end

  def create
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
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to :index_path, notice: 'El usuario se ha eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :role)
  end

  def set_user
    @user = User.find(params[:id])
  end

end