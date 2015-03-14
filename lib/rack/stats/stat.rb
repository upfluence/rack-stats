module Rack
  class Stats
    module Stat
      class Base
        def initialize(compute_name, compute_value = nil, condition = nil)
          @compute_name, @compute_value, @condition = \
            compute_name, compute_value, condition
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
            [@compute_name.call(request, duration, response)].compact.join('.'),
            @compute_value.call(request, duration, response)
          )
        end
      end

      class Increment < Base
        def send_data(batch, request, duration, response)
          batch.send(
            :increment,
            [@compute_name.call(request, duration, response)].compact.join('.')
          )
        end
      end
    end
  end
end
