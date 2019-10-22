require 'rails_helper'

RSpec.describe Transactions::Devices::Update do
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

      m.failure :find_device do
        'find_device'
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
    context 'missing device' do
      subject(:operation) { described_class.new }

      let(:params) { { id: 1, device: attributes_for(:device, user_id: user.id) } }

      it { expect(operation.call(input, &matcher)).to eq('find_device') }
    end

    context 'device exists' do
      context 'user is not owner' do
        subject(:operation) { described_class.new }

        let!(:device) { create(:device) }
        let(:params) { { id: device.id, device: device.attributes } }

        it { expect(operation.call(input, &matcher)).to eq('policy') }
      end

      context 'user is owner' do
        let!(:device) { create(:device, user: user) }
        let(:params) { { id: device.id, device: device.attributes.merge(name: 'updated') } }

        it { is_expected.to be_success }
        it { expect(result.success[:model]).to_not be_nil }
        it { expect { result }.to change { device.reload.name }.to('updated') }
      end
    end
  end

  context 'invalid params' do
    context 'empty params' do
      let(:params) { {} }

      it { expect(subject.failure[:id]).to eq(['is missing']) }
    end

    context 'missing user_id' do
      let(:params) { { id: 1, device: attributes_for(:device).merge(user_id: '') } }

      it { expect(subject.failure[:device][:user_id]).to eq(['must be filled']) }
    end

    context 'missing name' do
      let(:params) { { id: 1, device: attributes_for(:device).merge(name: '') } }

      it { expect(subject.failure[:device][:name]).to eq(['must be filled']) }
    end

    context 'missing timezone' do
      let(:params) { { id: 1, device: attributes_for(:device).merge(timezone: '') } }

      it { expect(subject.failure[:device][:timezone]).to eq(['must be filled']) }
    end
  end
end
