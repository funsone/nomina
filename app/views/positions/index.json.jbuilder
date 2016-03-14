json.array!(@positions) do |position|
  json.extract! position, :id, :titulo, :sueldo, :sueldo_minimo, :department_id
  json.url position_url(position, format: :json)
end
