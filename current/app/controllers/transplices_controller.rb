class TransplicesController < ApplicationController
  before_action :set_transplice, only: [:show, :edit, :update, :destroy]

  # GET /transplices
  # GET /transplices.json
  def index
    @transplices = Transplice.all
    @search = Transplice.ransack(params[:q])
    @sp = @search.result
    @spr =  @sp.paginate(:page => params[:page],:per_page => 100)
  end
def export
  @search = Transplice.ransack(params[:q])
    @data = @search.result
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv }
    end
     end
def import
    Transplice.import(params[:file])
    redirect_to transplices_url, notice: "List Imported"
  end
  # GET /transplices/1
  # GET /transplices/1.json
  def show
     @ensembl = HTTParty.get('http://rest.ensembl.org' + '/lookup/id/' + @transplice.gene,
    :headers =>{'Content-Type' => 'application/json'} )
    if @ensembl["display_name"].nil? 
     @name = "1"
    else
      @name = @ensembl["display_name"]

      @wikis = HTTParty.get('https://webservice.wikipathways.org/findPathwaysByText?query=' + @name + '&species=homo+sapiens&format=json',
      :headers =>{'Content-Type' => 'application/json'} )

      @pubs = HTTParty.get('https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmode=json&term='+ @name,
      :headers =>{'Content-Type' => 'application/json'} )
  
      @omim = HTTParty.get('https://api.omim.org/api/entry/search?search='+ @name+ '&start=0&limit=1&include=text:description&apiKey=6-p06gbQTZiAWNOpPn-CSw&format=xml',:headers =>{'Content-Type' => 'application/xml'} )
      
   

    end
end

  # GET /transplices/new
  def new
    @transplice = Transplice.new
    respond_to do |format|
    format.html
    format.js
  end
  end

  # GET /transplices/1/edit
  def edit
  end

  # POST /transplices
  # POST /transplices.json
  def create
    @transplice = Transplice.new(transplice_params)

    respond_to do |format|
      if @transplice.save
        format.html { redirect_to @transplice, notice: 'Transplice was successfully created.' }
        format.json { render :show, status: :created, location: @transplice }
      else
        format.html { render :new }
        format.json { render json: @transplice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transplices/1
  # PATCH/PUT /transplices/1.json
  def update
    respond_to do |format|
      if @transplice.update(transplice_params)
        format.html { redirect_to @transplice, notice: 'Transplice was successfully updated.' }
        format.json { render :show, status: :ok, location: @transplice }
      else
        format.html { render :edit }
        format.json { render json: @transplice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transplices/1
  # DELETE /transplices/1.json
  def destroy
    @transplice.destroy
    respond_to do |format|
      format.html { redirect_to transplices_url, notice: 'Transplice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transplice
      @transplice = Transplice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transplice_params
      params.require(:transplice).permit(:gene, :transcript, :psi, :sample_id)
    end
end
