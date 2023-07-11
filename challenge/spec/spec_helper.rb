#
# Settings env variables
#

# If tests are run from docker and if your API server is going to be running on your
# local machine exposing the API endpoint on localhost, you'll need to forward
# API calls from the dockerized spec application to your local machine's
# localhost. You should comment the localhost BASE_URL and uncomment the below one.
# This is what 'host.docker.internal' does:
#
#      docker spec application => host.docker.internal => host machine localhost
#

BASE_URL = 'http://localhost:3000'.freeze
# BASE_URL = 'http://host.docker.internal:3000'.freeze

#
# Spec env variables
# You should not have to modify those
#

HTTP_SUCCESS = 200
HTTP_UNPROCESSABLE = 422

GLEXPORT_ID = 1 # This company has no shipments
YALMART_ID = 2
DOSTCO_ID = 3

#
# Settings and helpers
# You should not have to modify those
#

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end

def http_get(url)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)

  request = Net::HTTP::Get.new(uri.request_uri)
  request['Content-Type'] = 'application/json'
  request['Accept'] = 'application/json'
  http.request(request)
end
