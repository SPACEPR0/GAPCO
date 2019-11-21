class AreasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_area, only: [:show, :edit, :update, :destroy]
  layout "areas_layout"

  # GET /areas
  # GET /areas.json
  def index
    @areas = Area.all
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
  end

  # GET /areas/new
  def new
    @area = Area.new
  end

  # GET /areas/1/edit
  def edit
  end

  # POST /areas
  # POST /areas.json
  def create
    if (current_user.role == 0) then
      @area = Area.new(area_params)

      respond_to do |format|
        if @area.save
          format.html { redirect_to @area }
          format.json { render :show, status: :created, location: @area }
        else
          format.html { render :new }
          format.json { render json: @area.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  # PATCH/PUT /areas/1
  # PATCH/PUT /areas/1.json
  def update
    if (current_user.role == 0) then
      respond_to do |format|
        if @area.update(area_params)
          format.html { redirect_to @area }
          format.json { render :show, status: :ok, location: @area }
        else
          format.html { render :edit }
          format.json { render json: @area.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    if (current_user.role == 0) then
      @area.destroy
      respond_to do |format|
        format.html { redirect_to areas_url }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
      params.require(:area).permit(:name, :user_id)
    end
end
