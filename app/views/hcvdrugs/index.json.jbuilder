json.array!(@hcvdrugs) do |hcvdrug|
  json.extract! hcvdrug, :id, :name, :region, :variant, :information
  json.url hcvdrug_url(hcvdrug, format: :json)
json.array!(@variants) do |variant|
  json.extract! variant, :id, :AAchange, :genotype, :drugrelation, :information
  json.url variant_url(variant, format: :json)
end
