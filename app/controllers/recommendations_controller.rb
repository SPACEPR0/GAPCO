class RecommendationsController < ApplicationController
  before_action :set_recommendation, only: [:show, :edit, :update, :destroy]
  layout "areas_layout"
  # GET /recommendations
  # GET /recommendations.json
  def index
    @recommendations = Recommendation.all
  end

  # GET /recommendations/1
  # GET /recommendations/1.json
  def show
    @goal = Goal.new
    @goal.recommendation_id = @recommendation.id
  end

  # GET /recommendations/new
  def new
    @recommendation = Recommendation.new
  end

  # GET /recommendations/1/edit
  def edit
  end

  # POST /recommendations
  # POST /recommendations.json
  def create
    area = Area.find(recommendation_params[:area_id])
    if (current_user == area.user || current_user.role == 0) then
      @recommendation = Recommendation.new(recommendation_params)
      respond_to do |format|
        if @recommendation.save

          format.html { redirect_to @recommendation.area }
          format.json { render :show, status: :created, location: @recommendation.area }
        else
          format.html { render :new }
          format.json { render json: @recommendation.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
    # Create notifications
    if (current_user.role === 0)then
      Notification.create(recipient: @recommendation.area.user, actor:current_user, action: " agregó una recomendación al área de " + @recommendation.area.name.to_s, notifiable: @recommendation)
    else
      Notification.create(recipient: User.find_by(role: 0), actor:current_user, action: " agregó una recomendación al área de " + @recommendation.area.name.to_s, notifiable: @recommendation)
    end
  end

  # PATCH/PUT /recommendations/1
  # PATCH/PUT /recommendations/1.json
  def update
    if (current_user == @recommendation.area.user || current_user.role == 0) then
      respond_to do |format|
        if @recommendation.update(recommendation_params)
          format.html { redirect_to @recommendation.area }
          format.json { render :show, status: :ok, location: @recommendation.area }
        else
          format.html { render :edit }
          format.json { render json: @recommendation.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
    # Create notifications
    if (current_user.role === 0)then
      Notification.create(recipient: @recommendation.area.user, actor:current_user, action: " editó una recomendación al área de " + @recommendation.area.name.to_s, notifiable: @recommendation)
    else
      Notification.create(recipient: User.find_by(role: 0), actor:current_user, action: " editó una recomendación al área de " + @recommendation.area.name.to_s, notifiable: @recommendation)
    end
  end

  # DELETE /recommendations/1
  # DELETE /recommendations/1.json
  def destroy
    if (current_user == @recommendation.area.user || current_user.role == 0) then
      # Create notifications
      if (current_user.role === 0)then
        Notification.create(recipient: @recommendation.area.user, actor:current_user, action: " eliminó una recomendación al área de " + @recommendation.area.name.to_s, notifiable: @recommendation.area)
      else
        Notification.create(recipient: User.find_by(role: 0), actor:current_user, action: " eliminó una recomendación al área de " + @recommendation.area.name.to_s, notifiable: @recommendation.area)
      end
      
      @recommendation.destroy
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
    def set_recommendation
      @recommendation = Recommendation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recommendation_params
      params.require(:recommendation).permit(:name, :area_id, :number, :time_limit, :time_beg)
    end
end
