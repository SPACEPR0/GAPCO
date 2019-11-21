class EvidencefilesController < ApplicationController
  before_action :set_evidencefile, only: [:show, :edit, :update, :destroy]

  # GET /evidencefiles
  # GET /evidencefiles.json
  def index
    @evidencefiles = Evidencefile.all
  end

  # GET /evidencefiles/1
  # GET /evidencefiles/1.json
  def show
  end

  # GET /evidencefiles/new
  def new
    @evidencefile = Evidencefile.new
  end

  # GET /evidencefiles/1/edit
  def edit
  end

  # POST /evidencefiles
  # POST /evidencefiles.json
  def create
    evidence = Evidence.find(evidencefile_params[:evidence_id])
    if (current_user == evidence.recommendation.area.user || current_user.role == 0)
      @evidencefile = Evidencefile.new(evidencefile_params)
      if @evidencefile.document.attachment then
        respond_to do |format|
          if @evidencefile.save
            format.js
            format.html { redirect_to edit_evidence_path @evidencefile.evidence }
            format.json { render :show, status: :created, location: @evidencefile }
          else
            format.html { render :new }
            format.json { render json: @evidencefile.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  # PATCH/PUT /evidencefiles/1
  # PATCH/PUT /evidencefiles/1.json
  def update
    if (current_user == @evidencefile.evidence.recommendations.area.user || current_user.role == 0)
      respond_to do |format|
        if @evidencefile.update(evidencefile_params)
          format.html { redirect_to @evidencefile, notice: 'Evidencefile was successfully updated.' }
          format.json { render :show, status: :ok, location: @evidencefile }
        else
          format.html { render :edit }
          format.json { render json: @evidencefile.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  # DELETE /evidencefiles/1
  # DELETE /evidencefiles/1.json
  def destroy
    if (current_user == @evidencefile.evidence.recommendations.area.user || current_user.role == 0)
      @evidence = @evidencefile.evidence
      @evidencefile.destroy
      respond_to do |format|
        format.js
        format.html { redirect_to @evidence }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evidencefile
      @evidencefile = Evidencefile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evidencefile_params
      params.require(:evidencefile).permit(:evidence_id, :document)
    end
end
