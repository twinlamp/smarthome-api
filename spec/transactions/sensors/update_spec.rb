# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Sensors::Update do
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

      m.failure :update do
        'update'
      end
    }
  }

  context 'valid params' do
    context 'missing sensor' do
      subject(:operation) { described_class.new }

      let(:params) { { id: 1, sensor: attributes_for(:sensor) } }

      it { expect(operation.call(input, &matcher)).to eq('find_sensor') }
    end

    context 'sensor exists' do
      context 'user is not owner' do
        subject(:operation) { described_class.new }

        let!(:sensor) { create(:sensor) }
        let(:params) { { id: sensor.id, sensor: sensor.attributes } }

        it { expect(operation.call(input, &matcher)).to eq('policy') }
      end

      context 'user is owner' do
        let!(:device) { create(:device, user: user) }
        let!(:sensor) { create(:sensor, device: device) }
        let(:params) { { id: sensor.id, sensor: sensor.attributes.merge(name: 'updated') } }

        it { is_expected.to be_success }
        it { expect(result.success[:model]).to_not be_nil }
        it { expect { result }.to change { sensor.reload.name }.to('updated') }
      end
    end
  end

  context 'invalid params' do
    context 'empty params' do
      let(:params) { {} }

      it { expect(subject.failure[:id]).to eq(['is missing']) }
    end

    context 'missing name' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(name: '') } }

      it { expect(subject.failure[:sensor][:name]).to eq(['must be filled']) }
    end

    context 'duplicate name' do
      let!(:sensor) { create(:sensor) }
      let!(:another_sensor) { create(:sensor, device: sensor.device) }
      let(:params) { { id: sensor.id, sensor: attributes_for(:sensor).merge(name: another_sensor.name) } }

      it { expect(subject.failure[:sensor][:name]).to eq(['must be unique']) }
    end

    context 'missing icon' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(icon: '') } }

      it { expect(subject.failure[:sensor][:icon]).to eq(['must be filled']) }
    end

    context 'missing min' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(min: '') } }

      it { expect(subject.failure[:sensor][:min]).to eq(['must be filled']) }
    end

    context 'missing max' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(max: '') } }

      it { expect(subject.failure[:sensor][:max]).to eq(['must be filled']) }
    end

    context 'min > max' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(min: 100, max: 0) } }

      it { expect(subject.failure[:sensor][:min]).to eq(['min should be < max']) }
    end
  end
end
