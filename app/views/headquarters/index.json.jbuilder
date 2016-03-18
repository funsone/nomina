json.array!(@headquarters) do |headquarter|
  json.extract! headquarter, :id, :nombre
  json.url headquarter_url(headquarter, format: :json)
end
