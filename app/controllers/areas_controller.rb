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
    areas = Area.all
    areas.order(number: :asc)
    # Create notifications
    Notification.create(recipient: @area.user, actor:current_user, action: " creó el área " + @area.name.to_s, notifiable: @area)
  end

  # PATCH/PUT /areas/1
  # PATCH/PUT /areas/1.json
  def update
    if (current_user.role == 0) then
      respond_to do |format|
        if @area.update(area_params)
          format.html { redirect_to @area }
          format.json { render :show, status: :ok, location: @area }
          format.pdf {report}
        else
          format.html { render :edit }
          format.json { render json: @area.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "No tienes permisos para realizar esta acción"
      return
    end

    # Create notifications
    if (current_user.role === 0)then
      Notification.create(recipient: @area.user, actor:current_user, action: " editó el área de " + @area.name.to_s, notifiable: @area)
    else
      Notification.create(recipient: User.find_by(role: 0), actor:current_user, action: " editó el área de " + @area.name.to_s, notifiable: @area)
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    # Create notifications
    Notification.create(recipient: @area.user, actor:current_user, action: " eliminó el área de " + @area.name.to_s, notifiable: @area.user)

    if (current_user.role == 0) then
      unlink_notifs_area @area, @area.user
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

  def report

    #Se elimina todo
    FileUtils.rm_rf(Dir[Rails.root.join('pdfs', '*')])

    #Se encuentra el area que se desea reportar
    @reported_area = Area.find(params[:id])

    #Se acomoda el período en caso de ser necesario
    if @reported_area.report_date_1 > @reported_area.report_date_2 then
      @reported_area.report_date_1, @reported_area.report_date_2 = @reported_area.report_date_2, @reported_area.report_date_1
    end

    #VARIABLES AUXILIARES
    @recomendaciones_validas =[]#Recomendaciones con evidencias dentro del periodo dado
    @recomendacion #Recomendación actual
    @evidencia #Evidencia actual
    @hay_evidencias #Bandera para indicar si la recomendación tiene evidencias que se puedan mostrar

    #Se toma LA PRIMER RECOMENDACIÓN para pegarla junto con la portada PARA NO DESPERDICIAR ESPACIO

    if @reported_area.recommendations.length > 0
      @recomendacion = @reported_area.recommendations[0]
      #Se ajusta el período de la primer recomendación en caso de ser necesario
      if @recomendacion.time_beg > @recomendacion.time_limit then
        @recomendacion.time_beg, @recomendacion.time_limit = @recomendacion.time_limit, @recomendacion.time_beg
      end

      #Se buscarán evidencias en el período dado por el usuario para saber si generaremos portadas para evidencias en la PRIMER RECOMENDACIÓN
      @hay_evidencias = false
      @recomendacion.evidences.each do |recom|
        if recom.day.between?(@reported_area.report_date_1, @reported_area.report_date_2)
          @hay_evidencias = true
          break
        end
      end
    else
      #SI NO HAY RECOMENDACIONES, ENTONCES SE HACE EL REPORTE VACÍO
      pdf = render_to_string pdf:'Report', template:'areas/report_cover.pdf.erb', :page_height => '11in', :page_width => '8.5in'
      save_path=Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
    end

    if @hay_evidencias then

      #Se recorren las evidencias para guardarlas en un arreglo y después ordenarlas respecto a las fechas
      evidencias_ordenadas = []
      @recomendacion.evidences.each do |ev|
        if ev.day.between?(@reported_area.report_date_1, @reported_area.report_date_2)
          evidencias_ordenadas.append(ev)
        end
      end

      evidencias_ordenadas.sort_by!{ |a| a.day}

      #*************************SE CONSTRUYE LA PRIMER EVIDENCIA******************************+
      #SE METEN LAS FOTITOS
      if evidencias_ordenadas[0].day.between?(@reported_area.report_date_1, @reported_area.report_date_2)
        @evidencia = evidencias_ordenadas[0]
      end

      #SE HACE LA PORTADA DEL REPORTE
      pdf = render_to_string pdf:'Report', template:'areas/report_cover.pdf.erb', :page_height => '11in', :page_width => '8.5in'
      save_path=Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end

      #Ahora, se buscan las evidencias en pdf
      @evidencia.evidencefiles.each do |f|
        if f.document.attachment then
          if f.document.filename.to_s.include? "pdf" then

            IO.copy_stream(open(ActiveStorage::Blob.service.send(:path_for, f.document.key)), Rails.root.join('pdfs',
            "evidence#{@recomendacion.to_s.gsub(' ', '')}_#{@evidencia.to_s.gsub(' ', '')}.pdf"))

            pdf = CombinePDF.new
            pdf << CombinePDF.load(Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf'), allow_optional_content: true)
            pdf << CombinePDF.load(Rails.root.join('pdfs',"evidence#{@recomendacion.to_s.gsub(' ', '')}_#{@evidencia.to_s.gsub(' ', '')}.pdf"), allow_optional_content: true)
            pdf.save Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')

          end
        end
      end
      #******************************************************************************************
      #--------------CONTINÚAS METIENDO LAS EVIDENCIAS DE LA PRIMER RECOMENDACIÓN------------
      evidencias_ordenadas.each do |ev|
        if ev != evidencias_ordenadas[0]
          @evidencia = ev
          #SE DECIDE SI SE VA A MOSTRAR LA EVIDENCIA ACTUAL PARA CONSTRUIR LAS PORTADAS NECESARIAS
          if ev.day.between?(@reported_area.report_date_1, @reported_area.report_date_2)

            #Se hace la portada de la evidencia con todo e imágenes
            pdf = render_to_string pdf:'Report', template:'areas/evidence.pdf.erb', :page_height => '11in', :page_width => '8.5in'
            save_path=Rails.root.join('pdfs', 'portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(@recomendacion).to_s+'.pdf')
            File.open(save_path, 'wb') do |file|
              file << pdf
            end

            #Se agrega esta portada de evidencia con todo e imágenes al reporte que existe hasta el momento
            pdf = CombinePDF.new
            pdf << CombinePDF.load(Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf'), allow_optional_content: true)
            pdf << CombinePDF.load(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(@recomendacion).to_s+'.pdf'), allow_optional_content: true)
            pdf.save Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')

            #Se elimina la portada de la evidencia con todo e imágenes porque ya no es util
            File.delete(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(@recomendacion).to_s+'.pdf')) if File.exist?(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(@recomendacion).to_s+'.pdf'))

            #Ahora, se buscan las evidencias en pdf
            ev.evidencefiles.each do |f|
              if f.document.attachment then
                if f.document.filename.to_s.include? "pdf" then

                  IO.copy_stream(open(ActiveStorage::Blob.service.send(:path_for, f.document.key)), Rails.root.join('pdfs',
                  "evidence#{@recomendacion.to_s.gsub(' ', '')}_#{ev.to_s.gsub(' ', '')}.pdf"))

                  pdf = CombinePDF.new
                  pdf << CombinePDF.load(Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf'), allow_optional_content: true)
                  pdf << CombinePDF.load(Rails.root.join('pdfs',"evidence#{@recomendacion.to_s.gsub(' ', '')}_#{ev.to_s.gsub(' ', '')}.pdf"), allow_optional_content: true)
                  pdf.save Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')

                end
              end
            end
          end
        end
      end
    else
      #SI NO HAY EVIDENCIAS, ENTONCES SE HACE EL REPORTE VACÍO
      pdf = render_to_string pdf:'Report', template:'areas/report_cover.pdf.erb', :page_height => '11in', :page_width => '8.5in'
      save_path=Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
    end
 
    #***********************************************************************************************************************************************************#

    #Se comienzan a iterar las demás recomendaciones para crear las evidencias
    @reported_area.recommendations.each do |rec|

      #Se acomoda el plazo de la recomendación en caso de ser necesario
      if rec.time_beg > rec.time_limit then
        rec.time_beg, rec.time_limit = rec.time_limit, rec.time_beg
      end
      #Se buscarán evidencias en el período dado por el usuario para saber si generaremos portadas para evidencias
      @hay_evidencias = false
      rec.evidences.each do |recom|
        if recom.day.between?(@reported_area.report_date_1, @reported_area.report_date_2)
          @hay_evidencias = true
          break
        end
      end

      if rec != @reported_area.recommendations[0]
        @recomendacion = rec #Se extrae la recomendación para hacer su pdf


        #Se construye la portada de la recomendación.
        pdf = render_to_string pdf:'Report', template:'areas/report.pdf.erb', :page_height => '11in', :page_width => '8.5in'
        save_path=Rails.root.join('pdfs', 'portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(rec).to_s+'.pdf')
        File.open(save_path, 'wb') do |file|
          file << pdf
        end

        #Se mezcla la portada de la recomendación con el reporte que hasta este momento existe
        pdf = CombinePDF.new
        pdf << CombinePDF.load(Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf'), allow_optional_content: true)
        pdf << CombinePDF.load(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(rec).to_s+'.pdf'), allow_optional_content: true)
        pdf.save Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')

        #Se elimina la portada que acabamos de agregar al reporte porque ya no nos sirve
        File.delete(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(rec).to_s+'.pdf')) if File.exist?(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(rec).to_s+'.pdf'))

        #Si anteriormente se encontraron evidencias dentro del período que nos dio el usuario, entonces se procede a hacer portadas de evidencias y agregarlas al reporte
        if @hay_evidencias then

          #Se recorren las evidencias para guardarlas en un arreglo y después ordenarlas respecto a las fechas
          evidencias_ordenadas = []
          rec.evidences.each do |ev|
            if ev.day.between?(@reported_area.report_date_1, @reported_area.report_date_2)
              evidencias_ordenadas.append(ev)
            end
          end

          evidencias_ordenadas.sort_by!{ |a| a.day}

          #Una vez ordenadas las evidencias se procede a hacer el reporte
          evidencias_ordenadas.each do |ev|
            
            @evidencia = ev
            #SE DECIDE SI SE VA A MOSTRAR LA EVIDENCIA ACTUAL PARA CONSTRUIR LAS PORTADAS NECESARIAS
            if ev.day.between?(@reported_area.report_date_1, @reported_area.report_date_2)

              #Se hace la portada de la evidencia con todo e imágenes
              pdf = render_to_string pdf:'Report', template:'areas/evidence.pdf.erb', :page_height => '11in', :page_width => '8.5in'
              save_path=Rails.root.join('pdfs', 'portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(rec).to_s+'.pdf')
              File.open(save_path, 'wb') do |file|
                file << pdf
              end

              #Se agrega esta portada de evidencia con todo e imágenes al reporte que existe hasta el momento
              pdf = CombinePDF.new
              pdf << CombinePDF.load(Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf'), allow_optional_content: true)
              pdf << CombinePDF.load(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(rec).to_s+'.pdf'), allow_optional_content: true)
              pdf.save Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')

              #Se elimina la portada de la evidencia con todo e imágenes porque ya no es util
              File.delete(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(rec).to_s+'.pdf')) if File.exist?(Rails.root.join('pdfs','portada'+@reported_area.to_s.gsub(' ', '')+@reported_area.recommendations.index(rec).to_s+'.pdf'))

              #Ahora, se buscan las evidencias en pdf
              ev.evidencefiles.each do |f|
                if f.document.attachment then
                  if f.document.filename.to_s.include? "pdf" then

                    IO.copy_stream(open(ActiveStorage::Blob.service.send(:path_for, f.document.key)), Rails.root.join('pdfs',
                    "evidence#{rec.to_s.gsub(' ', '')}_#{ev.to_s.gsub(' ', '')}.pdf"))

                    pdf = CombinePDF.new
                    pdf << CombinePDF.load(Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf'), allow_optional_content: true)
                    pdf << CombinePDF.load(Rails.root.join('pdfs',"evidence#{rec.to_s.gsub(' ', '')}_#{ev.to_s.gsub(' ', '')}.pdf"), allow_optional_content: true)
                    pdf.save Rails.root.join('pdfs', 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')

                  end
                end
              end
            end
          end
        end
      end
    end

    #Se eliminan las portadas porque ya no son importantes
    Dir.foreach(Rails.root.join('pdfs')) do |file|
      if (file.include?"portada" or file.include?"evidence") and file.exclude?"logo"
        File.delete(Rails.root.join('pdfs',file)) if File.exist?(Rails.root.join('pdfs',file))
      end
    end

    #Luego, se muestra el pdf final para que se pueda descargar
    pdf_filename = Rails.root.join("pdfs", 'reporte'+@reported_area.to_s.gsub(' ', '')+'.pdf')
    send_file(pdf_filename, :filename=>'Reporte_'+@reported_area.name.gsub(' ', '')+'.pdf', :type => "application/pdf", :disposition =>'inline' )

  end
  helper_method :report

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
      params.require(:area).permit(:name, :user_id, :number, :description, :report_date_1, :report_date_2)
    end
end
