require 'json'
require 'net/http'

RSpec.describe 'GET api/v1/shipments index' do
  # Finally, we will make our API more user friendly
  # by adding some sorting, filtering and pagination

  context 'sorting' do
    # Company YALMART has three shipments,
    # departing (in order of id) Jan 1, Jan 3, Jan 2

    context 'default sort' do
      it 'sorts by id ascending by default' do
        response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{YALMART_ID}"
        expect(response.code.to_i).to eq(HTTP_SUCCESS)
        json = JSON.parse(response.body)
        expect(json['shipments'].map { |shipment| shipment['id'] }).to eq([1, 2, 3])
      end
    end

    context 'international departure date' do
      it 'allows ascending sort' do
        response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{YALMART_ID}&sort=international_departure_date&direction=asc"
        expect(response.code.to_i).to eq(HTTP_SUCCESS)
        json = JSON.parse(response.body)
        expect(json['shipments'].map { |shipment| shipment['id'] }).to eq([1, 3, 2])
      end

      it 'allows descending sort' do
        response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{YALMART_ID}&sort=international_departure_date&direction=desc"
        expect(response.code.to_i).to eq(HTTP_SUCCESS)
        json = JSON.parse(response.body)
        expect(json['shipments'].map { |shipment| shipment['id'] }).to eq([2, 3, 1])
      end
    end
  end

  context 'filtering' do
    # Company YALMART has three shipments, two by ocean and one by truck

    context 'international_transportation_mode' do
      it 'filters by ocean' do
        response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{YALMART_ID}&international_transportation_mode=ocean"
        expect(response.code.to_i).to eq(HTTP_SUCCESS)
        json = JSON.parse(response.body)
        expect(json['shipments'].map { |shipment| shipment['id'] }).to match_array([1, 2])
      end

      it 'filters by truck' do
        response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{YALMART_ID}&international_transportation_mode=truck"
        expect(response.code.to_i).to eq(HTTP_SUCCESS)
        json = JSON.parse(response.body)
        expect(json['shipments'].map { |shipment| shipment['id'] }).to match_array([3])
      end
    end
  end

  context 'pagination' do
    # Company DOSTCO has six shipments, with ids [4, 5, 6, 7, 8, 9]

    context 'with no params' do
      it 'defaults to 4 results' do
        response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{DOSTCO_ID}"
        expect(response.code.to_i).to eq(HTTP_SUCCESS)
        json = JSON.parse(response.body)
        expect(json['shipments'].map { |shipment| shipment['id'] }).to eq([4, 5, 6, 7])
      end
    end

    context 'with page params' do
      it 'allows page navigation with the default 4 per page' do
        response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{DOSTCO_ID}&page=2"
        expect(response.code.to_i).to eq(HTTP_SUCCESS)
        json = JSON.parse(response.body)
        expect(json['shipments'].map { |shipment| shipment['id'] }).to eq([8, 9])
      end
    end

    context 'with explicit page and per params' do
      it 'allows custom pagination' do
        response = http_get "#{BASE_URL}/api/v1/shipments?company_id=#{DOSTCO_ID}&page=2&per=2"
        expect(response.code.to_i).to eq(HTTP_SUCCESS)
        json = JSON.parse(response.body)
        expect(json['shipments'].map { |shipment| shipment['id'] }).to eq([6, 7])
      end
    end
  end
end
