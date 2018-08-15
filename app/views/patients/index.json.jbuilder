json.array!(@patients) do |patient|
  json.extract! patient, :id, :FirstName, :LastName, :DOB, :Genotype, :Mutations, :Treatment, :Physician
  json.url patient_url(patient, format: :json)
end
