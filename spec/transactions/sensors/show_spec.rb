# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Sensors::Show do
  subject(:result) { described_class.new.(input) }
  let(:input) { { user: user, params: ActionController::Parameters.new(params) } }
  let!(:user) { create(:user) }
  let(:matcher) {
    proc { |m|
      m.success do
        'success'
      end

      m.failure :validate do
        'validate'
      end

      m.failure :find_sensor do
        'find_sensor'
      end

      m.failure :policy do
        'policy'
      end
    }
  }

  context 'valid params' do
    context 'missing sensor' do
      subject(:operation) { described_class.new }

      let(:params) { { id: 1 } }

      it { expect(operation.call(input, &matcher)).to eq('find_sensor') }
    end

    context 'sensor exists' do
      context 'user is not owner' do
        subject(:operation) { described_class.new }

        let!(:sensor) { create(:sensor) }
        let(:params) { { id: sensor.id } }

        it { expect(operation.call(input, &matcher)).to eq('policy') }
      end

      context 'user is owner' do
        let!(:device) { create(:device, user: user) }
        let!(:sensor) { create(:sensor, device: device) }
        let(:params) { { id: sensor.id } }

        it { is_expected.to be_success }
        it { expect(result.success[:model]).to_not be_nil }
      end
    end
  end

  context 'invalid params' do
    context 'missing id' do
      let(:params) { { id: nil } }

      it { expect(subject.failure[:id]).to eq(['must be filled']) }
    end
  end
end
