module Rack
  class Stats
    class Duration
      def initialize(ns)
        @ns = ns
      end

      def ms; @ns / 1_000_000; end
      def s; ms / 1_000; end
    end

    class Timer
      attr_reader :duration

      def time(&blk)
        t0 = Time.now.nsec
        r = blk.call
        @duration = Duration.new(Time.now.nsec - t0)
        r
      end
    end
  end
end
