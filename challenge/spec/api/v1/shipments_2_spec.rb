require 'json'
require 'net/http'

RSpec.describe 'GET api/v1/shipments index - shipment data only' do
  # In this second spec file, we test the structure of the returned json.
  # For now we will only build the payload for shipments.
  #
  # What should be returned when hitting
  # /api/v1/shipments?company_id=#{YALMART_ID}
  # {
  #   "shipments": [
  #     {
  #       "id": 1,
  #       "name": "yalmart apparel from china",
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

  context 'shipments json payload' do
    it 'includes all shipments for a specific company, with name and ids' do
      response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{YALMART_ID}"
      expect(response.code.to_i).to eq(HTTP_SUCCESS)

      json = JSON.parse(response.body)
      # Uncomment below to output the response json in your shell
      # puts JSON.pretty_generate(json)

      expect(json['shipments'].map { |shipment| shipment['id'] }).to include(1, 2, 3)
      expect(json['shipments'].map { |shipment| shipment['name'] }).to include('yalmart apparel from china')
    end
  end
end
