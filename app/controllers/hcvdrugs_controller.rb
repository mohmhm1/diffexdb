class HcvdrugsController < ApplicationController
  before_action :set_hcvdrug, only: [:show, :edit, :update, :destroy]

  # GET /hcvdrugs
  # GET /hcvdrugs.json
  def index
    @hcvdrugs = Hcvdrug.all
  end

  # GET /hcvdrugs/1
  # GET /hcvdrugs/1.json
  def show
  end

  # GET /hcvdrugs/new
  def new
    @hcvdrug = Hcvdrug.new
  end

  # GET /hcvdrugs/1/edit
  def edit
  end

  # POST /hcvdrugs
  # POST /hcvdrugs.json
  def create
    @hcvdrug = Hcvdrug.new(hcvdrug_params)

    respond_to do |format|
      if @hcvdrug.save
        format.html { redirect_to @hcvdrug, notice: 'Hcvdrug was successfully created.' }
        format.json { render :show, status: :created, location: @hcvdrug }
      else
        format.html { render :new }
        format.json { render json: @hcvdrug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hcvdrugs/1
  # PATCH/PUT /hcvdrugs/1.json
  def update
    respond_to do |format|
      if @hcvdrug.update(hcvdrug_params)
        format.html { redirect_to @hcvdrug, notice: 'Hcvdrug was successfully updated.' }
        format.json { render :show, status: :ok, location: @hcvdrug }
      else
        format.html { render :edit }
        format.json { render json: @hcvdrug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hcvdrugs/1
  # DELETE /hcvdrugs/1.json
  def destroy
    @hcvdrug.destroy
    respond_to do |format|
      format.html { redirect_to hcvdrugs_url, notice: 'Hcvdrug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hcvdrug
      @hcvdrug = Hcvdrug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hcvdrug_params
      params.require(:hcvdrug).permit(:name, :region, :variant, :information)
    end
end
