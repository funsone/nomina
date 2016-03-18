json.array!(@departments) do |department|
  json.extract! department, :id, :nombre, :headquarter_id
  json.url department_url(department, format: :json)
end
