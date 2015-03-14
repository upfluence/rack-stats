module Rack
  class Stats
    module Stat
      class Base
        def initialize(compute_name, compute_value = nil,
                       condition = nil, namespace = nil)
          @compute_name, @compute_value, @condition, @namespace = \
            compute_name, compute_value, condition, namespace
        end

        def execute(batch, request, duration, response)
          if @condition.nil? || @condition.call(request, duration, response)
            send_data(batch, request, duration, response)
          end
        end
      end

      class Timing < Base
        def send_data(batch, request, duration, response)
          batch.send(
            :timing,
            [
              @namespace,
              @compute_name.call(request, duration, response)
            ].flatten.compact.join('.'),
            @compute_value.call(request, duration, response)
          )
        end
      end

      class Increment < Base
        def send_data(batch, request, duration, response)
          batch.send(
            :increment,
            [
              @namespace,
              @compute_name.call(request, duration, response)
            ].flatten.compact.join('.')
          )
        end
      end
    end
  end
end
