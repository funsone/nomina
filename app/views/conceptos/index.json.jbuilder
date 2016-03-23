json.array!(@conceptos) do |concepto|
  json.extract! concepto, :id, :nombre, :formula, :modalidad_de_pago
  json.url concepto_url(concepto, format: :json)
end
