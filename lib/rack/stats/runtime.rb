require 'statsd'
require 'rack'
require 'rack/stats/timer'
require 'rack/stats/stat'

module Rack
  class Stats
    class Runtime
      def initialize(statsd, app, env, stats, namespace)
        @batch = Statsd::Batch.new statsd
        @app, @env, @timer = app, env, Timer.new
        @stats = stats.map do |stat|
          klass = stat[:type] == :increment ? Stat::Increment : Stat::Timing
          klass.new stat[:name], stat[:value], stat[:condition], namespace
        end
      end

      def execute
        r = @timer.time { @app.call(@env) }
        flush_data @timer.duration, Rack::Response.new(r.last, r.first, r[1])
        r
      end

      def flush_data(duration, response)
        @stats.each do |stat|
          stat.execute @batch, Rack::Request.new(@env), duration, response
        end

        @batch.flush
      end
    end
  end
end
