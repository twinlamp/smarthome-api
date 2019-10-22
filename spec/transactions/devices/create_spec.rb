require 'rails_helper'

RSpec.describe Transactions::Devices::Create do
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

      m.failure :policy do
        'policy'
      end

      m.failure :create_device do
        'create_device'
      end
    }
  }

  context 'missing user' do
    let(:params) { attributes_for(:device) }
    let(:user) { nil }
    subject(:operation) { described_class.new }

    it { expect(operation.call(input, &matcher)).to eq('policy') }
  end

  context 'valid params' do
    let(:params) { attributes_for(:device).except(:identity, :user_id) }

    it { is_expected.to be_success }
    it { expect(result.success[:model]).to_not be_nil }
    it { expect(result.success[:model].identity).to_not be_nil }
    it { expect(result.success[:model].user).to eq(user) }

    it { expect { result }.to change { Device.count }.by(1) }
  end

  context 'invalid params' do
    context 'empty params' do
      let(:params) { {} }

      it { expect(result.failure[:name]).to eq(['is missing']) }
    end

    context 'missing name' do
      let(:params) { attributes_for(:device).merge(name: '') }

      it { expect(result.failure[:name]).to eq(['must be filled']) }
    end

    context 'duplicate name' do
      let!(:old_device) { create(:device, user: user) }
      let(:params) { attributes_for(:device).merge(name: old_device.name) }

      it { expect(result.failure[:name]).to eq(['must be unique']) }
    end

    context 'missing timezone' do
      let(:params) { attributes_for(:device).merge(timezone: '') }

      it { expect(result.failure[:timezone]).to eq(['must be filled']) }
    end
  end
end
