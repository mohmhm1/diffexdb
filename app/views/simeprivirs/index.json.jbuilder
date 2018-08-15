json.array!(@simeprivirs) do |simeprivir|
  json.extract! simeprivir, :id
  json.url simeprivir_url(simeprivir, format: :json)
end
