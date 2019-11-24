class EvidencesController < ApplicationController
  before_action :set_evidence, only: [:show, :edit, :update, :destroy]
  layout "areas_layout"

  # GET /evidences
  # GET /evidences.json
  def index
    @evidences = Evidence.all
  end

  # GET /evidences/1
  # GET /evidences/1.json
  def show
  end

  # GET /evidences/new
  def new
    @evidence = Evidence.new
  end

  # GET /evidences/1/edit
  def edit
  end

  # POST /evidences
  # POST /evidences.json
  def create
    @evidence = Evidence.new(evidence_params)

    respond_to do |format|
      if @evidence.save
        format.html { redirect_to @evidence.recommendation }
        format.json { render :show, status: :created, location: @evidence }
      else
        format.html { render :new }
        format.json { render json: @evidence.errors, status: :unprocessable_entity }
      end
    end

    # Create notifications
    if (current_user.role === 0)then
      Notification.create(recipient: @evidence.recommendation.area.user, actor:current_user, action: " agregó una evidencia a " + @evidence.recommendation.name.to_s, notifiable: @evidence)
    else
      Notification.create(recipient: User.find_by(role: 0), actor:current_user, action: " agregó una evidencia a " + @evidence.recommendation.name.to_s, notifiable: @evidence)
    end
  end

  # PATCH/PUT /evidences/1
  # PATCH/PUT /evidences/1.json
  def update
    respond_to do |format|
      if @evidence.update(evidence_params)
        format.html { redirect_to @evidence.recommendation }
        format.json { render :show, status: :ok, location: @evidence }
      else
        format.html { render :edit }
        format.json { render json: @evidence.errors, status: :unprocessable_entity }
      end
    end

    # Create notifications
    if (current_user.role === 0)then
      Notification.create(recipient: @evidence.recommendation.area.user, actor:current_user, action: " editó una evidencia en " + @evidence.recommendation.name.to_s, notifiable: @evidence)
    else
      Notification.create(recipient: User.find_by(role: 0), actor:current_user, action: " editó una evidencia en " + @evidence.recommendation.name.to_s, notifiable: @evidence)
    end
  end

  # DELETE /evidences/1
  # DELETE /evidences/1.json
  def destroy
    @recommendation = @evidence.recommendation

    # Create notifications
    if (current_user.role === 0)then
      Notification.create(recipient: @evidence.recommendation.area.user, actor:current_user, action: " eliminó una evidencia en " + @evidence.recommendation.name.to_s, notifiable: @recommendation)
    else
      Notification.create(recipient: User.find_by(role: 0), actor:current_user, action: " eliminó una evidencia en " + @evidence.recommendation.name.to_s, notifiable: @recommendation)
    end

    @evidence.destroy
    respond_to do |format|
      format.html { redirect_to @recommendation }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evidence
      @evidence = Evidence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evidence_params
      params.require(:evidence).permit(:title, :description, :recommendation_id, :day)
    end
end
