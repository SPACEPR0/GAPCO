class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]

  # GET /goals
  # GET /goals.json
  def index
    @goals = Goal.all
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
  end

  # GET /goals/new
  def new
    @goal = Goal.new
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals
  # POST /goals.json
  def create
    if (current_user.role == 0) then
      @goal = Goal.new(goal_params)
      @goal.recommendation.id= params[:recommendation_id]

      respond_to do |format|
        if @goal.save
          format.html { redirect_to "recommendations/3", notice: 'Goal was successfully created.' }
          format.json { render :show, status: :created, location: @goal }
          format.js
        else
          format.html { render :new }
          format.json { render json: @goal.errors, status: :unprocessable_entity }
          format.js
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  # PATCH/PUT /goals/1
  # PATCH/PUT /goals/1.json
  def update
    if (current_user.role == 0) then
      respond_to do |format|
        if @goal.update(goal_params)
          format.html { redirect_to @goal, notice: 'Goal was successfully updated.' }
          format.json { render :show, status: :ok, location: @goal }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @goal.errors, status: :unprocessable_entity }
          format.js
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    if (current_user.role == 0) then
      @goal.destroy
      respond_to do |format|
        format.html { redirect_to goals_url, notice: 'Goal was successfully destroyed.' }
        format.json { head :no_content }
        format.js
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def goal_params
      params.require(:goal).permit(:title, :actions, :recommendation_id)
    end
end
