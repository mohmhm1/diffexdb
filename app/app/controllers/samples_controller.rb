class SamplesController < ApplicationController
  before_action :set_sample, only: [:show, :edit, :update, :destroy]
require 'rinruby'

  # GET /samples
  # GET /samples.json
  def index
    @samples = Sample.all
    @gth = Abundance.all
  end

  # GET /samples/1
  # GET /samples/1.json
  def show
  @white = Sample.ransack(race_eq: "WHITE")
  @whites = @white.result
  @NA= Sample.ransack(race_eq: "NA")
  @NAS = @NA.result
  @asian= Sample.ransack(race_eq: "ASIAN")
  @asians = @asian.result
  @african = Sample.ransack(race_eq: "BLACK OR AFRICAN AMERICAN")
  @africans = @african.result
  @search = Abundance.ransack(params[:q])
  @samples = @search.result
  @searchsplice = Splice.ransack(params[:q])
@sp = @sample.abundances.limit(1000).order('tpm DESC')

@sphigh = @sample.abundances.limit(50).order('tpm DESC')

  @sphigh1k = @sample.abundances.limit(1000).order('tpm DESC')
  @spSplice = @sample.transplices.limit(1000).order('psi DESC')

@sphighSplice = @sample.transplices.limit(50).order('dpsi DESC')

  @sphigh1kSplice= @sample.transplices.limit(1000).order('dpsi DESC')
  end
def export
    @search = Sample.ransack(params[:q])
    @data = @search.result
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv }
    end
  end
  # GET /samples/new
  def new
    @sample = Sample.new
  end

  # GET /samples/1/edit
  def edit
  end

  # POST /samples
  # POST /samples.json
  def create
    @sample = Sample.new(sample_params)

    respond_to do |format|
      if @sample.save
        format.html { redirect_to @sample, notice: 'Sample was successfully created.' }
        format.json { render :show, status: :created, location: @sample }
      else
        format.html { render :new }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /samples/1
  # PATCH/PUT /samples/1.json
  def update
    respond_to do |format|
      if @sample.update(sample_params)
        format.html { redirect_to @sample, notice: 'Sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @sample }
      else
        format.html { render :edit }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    Sample.import(params[:file])
    redirect_to samples_url, notice: "List Imported"
  end
  # DELETE /samples/1
  # DELETE /samples/1.json
  def destroy
    @sample.destroy
    respond_to do |format|
      format.html { redirect_to samples_url, notice: 'Sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
def index
    @search = Sample.ransack(params[:q])
    @samples = @search.result

  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sample_params
      params.require(:sample).permit(:bcr_patient_uuid, :file_name, :folder_name_from_manifest, :sample_id, :form_completion_date, :histologic_diagnosis, :prospective_collection, :retrospective_collection, :gender, :birth_days_to, :race, :ethnicity, :history_other_malignancy, :history_neoadjuvant_treatment, :initial_pathologic_dx_year, :ajcc_staging_edition, :ajcc_tumor_pathologic_pt, :ajcc_nodes_pathologic_pn, :ajcc_metastasis_pathologic_pm, :ajcc_pathologic_tumor_stage, :residual_tumor, :lymph_nodes_examined, :lymph_nodes_examined_count, :lymph_nodes_examined_he_count, :lymph_nodes_examined_ihc_count, :vital_status, :last_contact_days_to, :death_days_to, :tumor_status, :cea_level_pretreatment, :specimen_non_node_tumor_deposits, :circumferential_resection_margin_crm, :vascular_invasion_indicator, :lymphovascular_invasion_indicator, :perineural_invasion, :microsatellite_instability, :loci_tested_count, :loci_abnormal_count, :mismatch_rep_proteins_tested_by_ihc, :mismatch_rep_proteins_loss_ihc, :kras_gene_analysis_indicator, :kras_mutation_found, :kras_mutation_codon, :braf_gene_analysis_indicator, :braf_gene_analysis_result, :history_other_malignancy, :history_colon_polyps, :colon_polyps_at_procurement_indicator, :weight_kg_at_diagnosis, :height_cm_at_diagnosis, :family_history_colorectal_cancer, :radiation_treatment_adjuvant, :pharmaceutical_tx_adjuvant, :treatment_outcome_first_course, :new_tumor_event_dx_indicator, :age_at_initial_pathologic_diagnosis, :anatomic_neoplasm_subdivision, :clinical_M, :clinical_N, :clinical_T, :clinical_stage, :days_to_initial_pathologic_diagnosis, :days_to_patient_progression_free, :days_to_tumor_progression, :disease_code, :eastern_cancer_oncology_group, :extranodal_involvement, :icd_10, :icd_o_3_histology, :icd_o_3_site, :informed_consent_verified, :initial_pathologic_diagnosis_method, :karnofsky_performance_score, :number_pack_years_smoked, :patient_id, :project_code, :stage_other, :stopped_smoking_year, :tissue_source_site, :tobacco_smoking_history, :tumor_tissue_site, :year_of_tobacco_smoking_onset)
    end
end
