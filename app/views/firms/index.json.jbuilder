json.array!(@firms) do |firm|
  json.extract! firm, :name, :url, :principals, :address, :zipcode, :city, :state
  json.url firm_url(firm, format: :json)
end
