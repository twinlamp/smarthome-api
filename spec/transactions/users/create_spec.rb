# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Users::Create do
  subject(:result) { described_class.new.(input) }
  let(:input) { { params: ActionController::Parameters.new(params) } }

  context 'valid params' do
    let(:params) { attributes_for(:user) }

    it { is_expected.to be_success }
    it { expect(result.success[:model]).to_not be_nil }
    it { expect(result.success[:token]).to_not be_nil }
    it { expect(result.success[:expire]).to_not be_nil }

    it { expect { result }.to change { User.count }.by(1) }
  end

  context 'invalid params' do
    context 'empty params' do
      let(:params) { {} }

      it { expect(result.failure[:email]).to eq(['is missing']) }
    end

    context 'missing email' do
      let(:params) { attributes_for(:user).merge(email: '') }

      it { expect(result.failure[:email]).to eq(['must be filled']) }
    end

    context 'duplicate email' do
      let!(:user) { create(:user) }
      let(:params) { attributes_for(:user).merge(email: user.email) }

      it { expect(result.failure[:email]).to eq(['must be unique']) }
    end

    context 'missing password' do
      let(:params) { attributes_for(:user).merge(password: '') }

      it { expect(result.failure[:password]).to eq(['must be filled']) }
    end

    context 'short password' do
      let(:params) { attributes_for(:user).merge(password: 'qwerty') }

      it { expect(result.failure[:password]).to eq(['size cannot be less than 8']) }
    end
  end
end
