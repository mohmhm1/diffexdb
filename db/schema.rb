# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180809212425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abundances", force: :cascade do |t|
    t.string   "sample_id"
    t.string   "target_id"
    t.decimal  "length"
    t.decimal  "eff_length"
    t.decimal  "est_counts"
    t.decimal  "tpm"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notes"
    t.boolean  "flag"
  end

  add_index "abundances", ["created_at"], name: "index_abundances_on_created_at", using: :btree
  add_index "abundances", ["flag"], name: "index_abundances_on_flag", using: :btree
  add_index "abundances", ["notes"], name: "index_abundances_on_notes", using: :btree
  add_index "abundances", ["updated_at"], name: "index_abundances_on_updated_at", using: :btree

  create_table "samples", force: :cascade do |t|
    t.string   "bcr_patient_uuid"
    t.string   "file_name"
    t.string   "folder_name_from_manifest"
    t.string   "sample_id"
    t.date     "form_completion_date"
    t.string   "histologic_diagnosis"
    t.string   "prospective_collection"
    t.string   "retrospective_collection"
    t.string   "gender"
    t.string   "birth_days_to"
    t.string   "race"
    t.string   "ethnicity"
    t.string   "history_other_malignancy"
    t.string   "history_neoadjuvant_treatment"
    t.string   "initial_pathologic_dx_year"
    t.string   "ajcc_staging_edition"
    t.string   "ajcc_tumor_pathologic_pt"
    t.string   "ajcc_nodes_pathologic_pn"
    t.string   "ajcc_metastasis_pathologic_pm"
    t.string   "ajcc_pathologic_tumor_stage"
    t.string   "residual_tumor"
    t.string   "lymph_nodes_examined"
    t.string   "lymph_nodes_examined_count"
    t.integer  "lymph_nodes_examined_he_count"
    t.integer  "lymph_nodes_examined_ihc_count"
    t.string   "vital_status"
    t.integer  "last_contact_days_to"
    t.integer  "death_days_to"
    t.string   "tumor_status"
    t.integer  "cea_level_pretreatment"
    t.string   "specimen_non_node_tumor_deposits"
    t.integer  "circumferential_resection_margin_crm"
    t.string   "vascular_invasion_indicator"
    t.string   "lymphovascular_invasion_indicator"
    t.string   "perineural_invasion"
    t.string   "microsatellite_instability"
    t.string   "loci_tested_count"
    t.string   "loci_abnormal_count"
    t.string   "mismatch_rep_proteins_tested_by_ihc"
    t.string   "mismatch_rep_proteins_loss_ihc"
    t.string   "kras_gene_analysis_indicator"
    t.string   "kras_mutation_found"
    t.string   "kras_mutation_codon"
    t.string   "braf_gene_analysis_indicator"
    t.string   "braf_gene_analysis_result"
    t.string   "history_colon_polyps"
    t.string   "colon_polyps_at_procurement_indicator"
    t.integer  "weight_kg_at_diagnosis"
    t.integer  "height_cm_at_diagnosis"
    t.integer  "family_history_colorectal_cancer"
    t.string   "radiation_treatment_adjuvant"
    t.string   "pharmaceutical_tx_adjuvant"
    t.string   "treatment_outcome_first_course"
    t.string   "new_tumor_event_dx_indicator"
    t.integer  "age_at_initial_pathologic_diagnosis"
    t.string   "anatomic_neoplasm_subdivision"
    t.string   "clinical_M"
    t.string   "clinical_N"
    t.string   "clinical_T"
    t.string   "clinical_stage"
    t.string   "days_to_initial_pathologic_diagnosis"
    t.string   "days_to_patient_progression_free"
    t.string   "days_to_tumor_progression"
    t.string   "disease_code"
    t.string   "eastern_cancer_oncology_group"
    t.string   "extranodal_involvement"
    t.string   "icd_10"
    t.string   "icd_o_3_histology"
    t.string   "icd_o_3_site"
    t.string   "informed_consent_verified"
    t.string   "initial_pathologic_diagnosis_method"
    t.string   "karnofsky_performance_score"
    t.string   "number_pack_years_smoked"
    t.string   "patient_id"
    t.string   "project_code"
    t.string   "stage_other"
    t.string   "stopped_smoking_year"
    t.string   "tissue_source_site"
    t.string   "tobacco_smoking_history"
    t.string   "tumor_tissue_site"
    t.string   "year_of_tobacco_smoking_onset"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_bool"
    t.integer  "days_to_event"
    t.integer  "event"
  end

  add_index "samples", ["sample_id"], name: "index_samples_on_sample_id", using: :btree

  create_table "sleuths", force: :cascade do |t|
    t.string   "target_id"
    t.decimal  "test_stat"
    t.decimal  "pval"
    t.decimal  "qval"
    t.decimal  "rsssigma_sq"
    t.decimal  "tech_var"
    t.decimal  "mean_obs"
    t.decimal  "var_obs"
    t.decimal  "sigma_sq_pmax"
    t.decimal  "smooth_sigma_sq"
    t.decimal  "final_sigma_sq"
    t.integer  "degrees_free"
    t.string   "ens_gene"
    t.string   "ext_gene"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rss"
    t.string   "biotype"
    t.string   "model"
  end

  create_table "splices", force: :cascade do |t|
    t.string   "sample_id"
    t.string   "ensembl"
    t.string   "event"
    t.string   "coordinates"
    t.decimal  "dpsi",        precision: 9, scale: 8
    t.integer  "pval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "splices", ["coordinates"], name: "index_splices_on_coordinates", using: :btree
  add_index "splices", ["dpsi"], name: "index_splices_on_dpsi", using: :btree
  add_index "splices", ["ensembl"], name: "index_splices_on_ensembl", using: :btree
  add_index "splices", ["event"], name: "index_splices_on_event", using: :btree
  add_index "splices", ["pval"], name: "index_splices_on_pval", using: :btree
  add_index "splices", ["sample_id"], name: "index_splices_on_sample_id", using: :btree

  create_table "transplices", force: :cascade do |t|
    t.string   "gene"
    t.string   "transcript"
    t.decimal  "psi"
    t.string   "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notes"
    t.boolean  "flag"
  end

  add_index "transplices", ["gene"], name: "index_transplices_on_gene", using: :btree
  add_index "transplices", ["psi"], name: "index_transplices_on_psi", using: :btree
  add_index "transplices", ["sample_id"], name: "index_transplices_on_sample_id", using: :btree
  add_index "transplices", ["transcript"], name: "index_transplices_on_transcript", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.boolean  "approved",               default: false, null: false
  end

  add_index "users", ["approved"], name: "index_users_on_approved", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

end
