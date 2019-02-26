class SleuthsController < ApplicationController
  before_action :set_sleuth, only: [:show, :edit, :update, :destroy]

  # GET /sleuths
  # GET /sleuths.json
  def index
    @search = Sleuth.ransack(params[:q])
    @sleuths = @search.result
    @sleuthz= @sleuths.paginate(:page => params[:page],:per_page => 1000).order('qval ASC')
    @sleuthqval= @sleuthz
    end

  # GET /sleuths/1
  # GET /sleuths/1.json
  def show
    @sleuths = HTTParty.get('https://webservice.wikipathways.org/findPathwaysByText?query=' + @sleuth.ext_gene + '&species=homo+sapiens&format=json',
    :headers =>{'Content-Type' => 'application/json'} )
    @pubs = HTTParty.get('https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmode=json&term='+ @sleuth.ext_gene,
      :headers =>{'Content-Type' => 'application/json'} )
  end
def export
    @search = Sleuth.ransack(params[:q])
    @data = @search.result
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv }
    end
  end
  # GET /sleuths/new
  def new
    @sleuth = Sleuth.new
  end
def import
    Sleuth.import(params[:file])
    redirect_to sleuths_url, notice: "List Imported"
  end
  # GET /sleuths/1/edit
  def edit
  end

  # POST /sleuths
  # POST /sleuths.json
  def create
    @sleuth = Sleuth.new(sleuth_params)

    respond_to do |format|
      if @sleuth.save
        format.html { redirect_to @sleuth, notice: 'Sleuth was successfully created.' }
        format.json { render :show, status: :created, location: @sleuth }
      else
        format.html { render :new }
        format.json { render json: @sleuth.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sleuths/1
  # PATCH/PUT /sleuths/1.json
  def update
    respond_to do |format|
      if @sleuth.update(sleuth_params)
        format.html { redirect_to @sleuth, notice: 'Sleuth was successfully updated.' }
        format.json { render :show, status: :ok, location: @sleuth }
      else
        format.html { render :edit }
        format.json { render json: @sleuth.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sleuths/1
  # DELETE /sleuths/1.json
  def destroy
    @sleuth.destroy
    respond_to do |format|
      format.html { redirect_to sleuths_url, notice: 'Sleuth was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sleuth
      @sleuth = Sleuth.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sleuth_params
      params.require(:sleuth).permit(:target_id, :test_stat, :pval, :qval, :rsssigma_sq, :tech_var, :mean_obs, :var_obs, :sigma_sq_pmax, :smooth_sigma_sq, :final_sigma_sq, :degrees_free, :ens_gene, :ext_gene)
    end
end
