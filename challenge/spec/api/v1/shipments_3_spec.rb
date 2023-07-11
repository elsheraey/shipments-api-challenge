require 'json'
require 'net/http'

RSpec.describe 'GET api/v1/shipments index - shipment data only' do
  # In this third spec file, we test the structure of the returned json.
  # We now include product relationships for every shipment, including
  # the product quantity for this given shipment.
  #
  # What should be returned when hitting
  # /api/v1/shipments?company_id=#{YALMART_ID}
  # {
  #   "shipments": [
  #     {
  #       "id": 1,
  #       "name": "yalmart apparel from china",
  #       "products": [
  #         {
  #           "quantity": 123,
  #           "id": 1,
  #           "sku": "shoe1",
  #           "description": "shoes",
  #           "active_shipment_count": 1
  #         },
  #         {
  #           "quantity": 234,
  #           "id": 2,
  #           "sku": "pant1",
  #           "description": "pants",
  #           "active_shipment_count": 2
  #         }
  #       ]
  #     },
  #     {
  #       "id": 2,
  #       ...
  #     },
  #     {
  #       "id": 3,
  #       ...
  #     }
  #   ]
  # }

  context 'products json' do
    it 'includes product info and shipment specific product information' do
      response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{YALMART_ID}"
      expect(response.code.to_i).to eq(HTTP_SUCCESS)
      json = JSON.parse(response.body)
      yalmart_apparel_from_china_shipment = json['shipments'].find { |shipment| shipment['name'] == 'yalmart apparel from china' }
      products = yalmart_apparel_from_china_shipment['products']
      expect(products.map { |product| product['id'].to_i }).to match_array([1, 2]) # match_array matches true for both [1,2] and [2,1]
      expect(products.map { |product| product['sku'] }).to match_array(%w[shoe1 pant1])
      expect(products.map { |product| product['description'] }).to match_array(%w[shoes pants])
      expect(products.map { |product| product['quantity'].to_i }).to match_array([123, 234])
    end

    it 'includes the calculated attribute active_shipment_count' do
      # This active_shipment_count field should be a code smell to you
      response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{YALMART_ID}"
      expect(response.code.to_i).to eq(HTTP_SUCCESS)
      json = JSON.parse(response.body)
      yalmart_apparel_from_china_shipment = json['shipments'].find { |shipment| shipment['name'] == 'yalmart apparel from china' }
      products = yalmart_apparel_from_china_shipment['products']
      expect(products.map { |product| product['active_shipment_count'].to_i }).to match_array([1, 2])
    end
  end
end
