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
    @evidence.evidencefiles.build
  end

  # GET /evidences/1/edit
  def edit
    @evidence.evidencefiles.build
  end

  # POST /evidences
  # POST /evidences.json
  def create
    recommendation = Recommendation.find(evidence_params[:recommendation_id])
    if (current_user = recommendation.area.user || current_user.role == 0) then
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
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  # PATCH/PUT /evidences/1
  # PATCH/PUT /evidences/1.json
  def update
    if (current_user.role == 0 || current_user = @evidence.recommendation.area.user) then
      respond_to do |format|
        if @evidence.update(evidence_params)
          format.html { redirect_to @evidence.recommendation }
          format.json { render :show, status: :ok, location: @evidence }
        else
          format.html { render :edit }
          format.json { render json: @evidence.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  # DELETE /evidences/1
  # DELETE /evidences/1.json
  def destroy
    if (current_user.role == 0 || current_user = @evidence.recommendation.area.user) then
      @recommendation = @evidence.recommendation
      @evidence.destroy
      respond_to do |format|
        format.html { redirect_to @recommendation }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evidence
      @evidence = Evidence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evidence_params
      params.require(:evidence).permit(:title, :description, :recommendation_id, :day, evidencefiles_attributes: [:document, :_destroy])
    end
end
