require 'rubygems'

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'geoip'
require 'rack'
require 'time'

class GeoipEntry < ActiveRecord::Base
end

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

post '/location_save' do
  locations = request.env["rack.input"].read.split(';')
  GeoipEntry.create(:ip_address => request.ip, :user_agent => request.user_agent, :w3c_latitude => locations[0],
    :w3c_longitude => locations[1], :ip_latitude => locations[2], :ip_longitude => locations[3], :distance => locations[4])
end

get '/locations' do
  entries = []
  GeoipEntry.find(:all).each do |e|
    entries << e.entry
  end
  entries.to_json
end

get '/' do
  erb :vpn
end

  