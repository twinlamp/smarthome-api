require 'rails_helper'

RSpec.describe Transactions::Sensors::Update do
  subject(:result) { described_class.new.(data) }
  let(:input) { { params: params } }

  context 'valid params' do
    context 'missing sensor' do
      subject(:operation) { described_class.new }

      let(:params) { { id: 1, sensor: attributes_for(:sensor) } }

      it { expect { |block| operation.call(input, &block) }.to fail_at(:find_sensor) }
    end

    context 'sensor exists' do
      context 'user is not owner' do
        subject(:operation) { described_class.new }

        let!(:sensor) { create(:sensor) }
        let!(:user) { create(:user) }
        let(:params) { { id: sensor.id, sensor: sensor.attributes, user: user } }

        it { expect { |block| operation.call(input, &block) }.to fail_at(:policy) }
      end

      context 'user is owner' do
        let!(:user) { create(:user) }
        let!(:sensor) { create(:sensor, user: user) }
        let(:params) { sensor.attributes.merge(name: 'updated') }

        it { is_expected.to be_success }
        it { expect(result.success[:model]).to_not be_nil }
        it { expect { result }.to change { sensor.reload.name }.to('updated') }
      end
    end
  end

  context 'invalid params' do
    context 'empty params' do
      let(:params) { {} }

      it { is_expected.to have_errors_on(id: :key?) }
    end

    context 'missing name' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(name: '') } }

      it { is_expected.to have_errors_on(sensor: { name: :filled? }) }
    end

    context 'duplicate name' do
      let!(:sensor) { create(:sensor) }
      let!(:another_sensor) { create(:sensor, device: sensor.device) }
      let(:params) { { id: sensor.id, sensor: attributes_for(:sensor).merge(name: another_sensor.name) } }

      it { is_expected.to have_errors_on(name: :unique?) }
    end

    context 'missing icon' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(icon: '') } }

      it { is_expected.to have_errors_on(sensor: { icon: :filled? }) }
    end

    context 'missing min' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(min: '') } }

      it { is_expected.to have_errors_on(sensor: { min: :filled? }) }
    end

    context 'missing max' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(max: '') } }

      it { is_expected.to have_errors_on(sensor: { max: :filled? }) }
    end

    context 'min > max' do
      let(:params) { { id: 1, sensor: attributes_for(:sensor).merge(min: 100, max: 0) } }

      it { is_expected.to have_errors_on(sensor: { max: :min_gt_max? }) }
    end
  end
end
