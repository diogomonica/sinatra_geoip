require 'rubygems'

require 'sinatra'
require 'json'
require 'geoip'
require 'rack'

configure do
  GEOIP = GeoIP.new('GeoLiteCity.dat')
end

configure :production do
  ENV['APP_ROOT'] ||= File.dirname(__FILE__)
  $:.unshift "#{ENV['APP_ROOT']}/vendor/plugins/newrelic_rpm/lib"
  require 'newrelic_rpm'
end

get '/locate' do
  response['Access-Control-Allow-Origin'] = "*"
  result = {:message => "Something went wrong while geolocating your IP Address!"}.to_json
  if geoip_result = GEOIP.city(request.ip)
    result = geoip_result.to_hash
  end
  result.to_json
end
