require 'rubygems'

require 'sinatra'
require 'json'
require 'geoip'

configure do
  GEOIP = GeoIP.new('GeoLiteCity.dat')
end

get '/hi' do
  response['Access-Control-Allow-Origin'] = "*"
  returnable = {:message => "you didn't supply an IP to geocode!"}
  if geoip_result = GEOIP.city(request.ip)
    returnable = geoip_result.to_hash
  end

  returnable.to_json
end
