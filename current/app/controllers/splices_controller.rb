class SplicesController < ApplicationController
  before_action :set_splice, only: [:show, :edit, :update, :destroy]

  # GET /splices
  # GET /splices.json
  def index
    @search = Splice.ransack(params[:q])
    @splices = @search.result
    @splicez =  @splices.paginate(:page => params[:page],:per_page => 50)
  end
def export
    @search = Splice.ransack(params[:q])
    @data = @search.result
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv }
    end
  end
  # GET /splices/1
  # GET /splices/1.json
  def show
  @search = Splice.ransack(params[:q])
  @splices = @search.results
  @splices = @search.results
  end

  def import
    Splice.import(params[:file])
    redirect_to splices_url, notice: "List Imported"
  end
  # GET /splices/new
  def new
    @splice = Splice.new
  end

  # GET /splices/1/edit
  def edit
  end

  # POST /splices
  # POST /splices.json
  def create
    @splice = Splice.new(splice_params)

    respond_to do |format|
      if @splice.save
        format.html { redirect_to @splice, notice: 'Splice was successfully created.' }
        format.json { render :show, status: :created, location: @splice }
      else
        format.html { render :new }
        format.json { render json: @splice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /splices/1
  # PATCH/PUT /splices/1.json
  def update
    respond_to do |format|
      if @splice.update(splice_params)
        format.html { redirect_to @splice, notice: 'Splice was successfully updated.' }
        format.json { render :show, status: :ok, location: @splice }
      else
        format.html { render :edit }
        format.json { render json: @splice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /splices/1
  # DELETE /splices/1.json
  def destroy
    @splice.destroy
    respond_to do |format|
      format.html { redirect_to splices_url, notice: 'Splice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_splice
      @splice = Splice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def splice_params
      params.require(:splice).permit(:sample_id, :ensembl, :event, :coordinates, :dpsi, :pval)
    end
end
