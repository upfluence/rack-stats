require 'spec_helper'

describe Rack::Stats do
  let(:middleware) { Rack::Stats.new(app, args) }
  let(:app) { -> (e) { [200, { 'Content-Length' => 3 }, ['foo']] } }
  let(:args) { { stats: [] } }
  let(:env) { double }
  let(:inc) { { name: -> (*_args) { 'foo' }, type: :increment } }
  let(:tim) do
    { name: -> (*_args) { 'foo' }, value: -> (*_args) { 42 }, type: :timing }
  end

  after { middleware.call(env) }

  subject { Statsd::Batch  }

  describe 'no stats' do
    it { expect_any_instance_of(subject).to_not receive(:timing) }
    it { expect_any_instance_of(subject).to_not receive(:increment) }
  end

  describe 'increment metric' do
    let(:args) { { stats: [inc] } }

    it { expect_any_instance_of(subject).to_not receive(:timing) }
    it do
      expect_any_instance_of(subject).to receive(:increment).with('foo').once
    end
  end

  describe 'timing metric' do
    let(:args) { { stats: [tim] } }

    it { expect_any_instance_of(subject).to_not receive(:increment) }
    it do
      expect_any_instance_of(subject).to receive(:timing).with('foo', 42).once
    end
  end

  describe 'both types at the same time' do
    let(:args) { { stats: [tim, inc] } }

    it do
      expect_any_instance_of(subject).to receive(:increment).with('foo').once
    end
    it do
      expect_any_instance_of(subject).to receive(:timing).with('foo', 42).once
    end
  end
end
