require 'rack/stats/version'
require 'rack/stats/runtime'

module Rack
  class Stats
    DEFAULT_STATS = [
      {
        name: -> (*_args) { 'request_duration_global' },
        value: -> (_req, d, _resp) { d.ms },
        type: :timing
      },
      {
        name: lambda do |req, _d, _resp|
          [
            req.path.eql?('/') ? 'index' : req.path.gsub(/\//, '-'),
            req.request_method.downcase,
            'request_duration'
          ]
        end,
        value: -> (_req, d, _resp) { d.ms },
        type: :timing
      },
      {
        name: -> (*_args) { 'request_number' },
        type: :increment
      },
      {
        name: lambda do |_req, _d, resp|
          ['request_number_status', "#{resp.status / 100}XX"]
        end,
        type: :increment
      }
    ]

    def initialize(app, args = {})
      @app = app
      @namespace = args.fetch(:namespace, ENV['RACK_STATS_NAMESPACE'])
      @statsd = Statsd.new(*args.fetch(:statsd, '127.0.0.1:8125').split(':'))
      @statsd.tap { |sd| sd.namespace = @namespace } if @namespace
      @stats = args.fetch(:stats, DEFAULT_STATS)
    end

    def call(env)
      Runtime.new(@statsd, @app, env, @stats).execute
    end
  end
end
