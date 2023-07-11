require 'json'
require 'net/http'

RSpec.describe 'GET api/v1/shipments index - endpoint initialization' do
  # In this first spec file, we will simply validate that our endpoint is
  # returning some data when a company_id is provided, and an error otherwise.
  #
  # TIP: You can make these tests pass without even connecting to the DB.
  # Simply return an empty paylod for all company_id params.
  #
  # What should be returned when hitting
  # /api/v1/shipments?company_id=#{GLEXPORT_ID}
  # {
  #   "shipments": []
  # }
  #

  context 'with valid params' do
    it 'returns 200 and an empty payload for a company without shipments' do
      response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{GLEXPORT_ID}"
      expect(response.code.to_i).to eq(HTTP_SUCCESS)
      json = JSON.parse(response.body)
      expect(json['shipments']).to eq []
    end
  end

  context 'with invalid params' do
    context 'company_id is not provided' do
      it 'returns an errored response and a useful error message' do
        response = http_get "#{BASE_URL}/api/v1/shipments"
        expect(response.code.to_i).to eq(HTTP_UNPROCESSABLE)
        json = JSON.parse(response.body)
        expect(json['errors']).to eq(['company_id is required'])
      end
    end
  end
end
