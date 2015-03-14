require 'sinatra'
require 'rack/stats'

use Rack::Stats

get '/' do
  [200, 'foo']
end

get '/foo' do
  [201, 'bar']
end
