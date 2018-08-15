json.array!(@variants) do |variant|
  json.extract! variant, :id, :AAchange, :genotype, :drugrelation, :information
  json.url variant_url(variant, format: :json)
end
