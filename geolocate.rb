require 'rubygems'

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'geoip'
require 'rack'
require 'time'

class GeoipEntry < ActiveRecord::Base
  validates_presence_of :entry
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
  GeoipEntry.create(:entry => Time.now.to_s + ';' + request.env["rack.input"].read)
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

  