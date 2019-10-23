# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::SensorValues::Index do
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

      m.failure :find_values do
        'find_values'
      end
    }
  }

  context 'valid params' do
    context 'missing sensor' do
      subject(:operation) { described_class.new }

      let(:params) { { sensor_id: 1 } }

      it { expect(operation.call(input, &matcher)).to eq('find_sensor') }
    end

    context 'sensor exists' do
      context 'user is not owner' do
        subject(:operation) { described_class.new }

        let!(:sensor) { create(:sensor) }
        let(:params) { { sensor_id: sensor.id } }

        it { expect(operation.call(input, &matcher)).to eq('policy') }
      end

      context 'user is owner' do
        let!(:device) { create(:device, user: user) }
        let!(:sensor) { create(:sensor, device: device) }
        let!(:sensor_values) { create_list(:sensor_value, 5, sensor: sensor) }
        let(:params) { { sensor_id: sensor.id } }

        it { is_expected.to be_success }
        it { expect(result.success[:data].length).to eq(5) }

        context 'time scope is limited' do
          let(:params) { { sensor_id: sensor.id, from: sensor_values[-2].registered_at.iso8601 } }

          it { expect(result.success[:data].length).to eq(4) }
        end
      end
    end
  end

  context 'invalid params' do
    context 'missing sensor_id' do
      let(:params) { { sensor_id: nil } }

      it { expect(subject.failure[:sensor_id]).to eq(['must be filled']) }
    end
  end
end
