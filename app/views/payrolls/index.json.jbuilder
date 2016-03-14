json.array!(@payrolls) do |payroll|
  json.extract! payroll, :id, :nombre
  json.url payroll_url(payroll, format: :json)
end
