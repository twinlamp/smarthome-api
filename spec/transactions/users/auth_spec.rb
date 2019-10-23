# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Users::Auth do
  subject(:result) { described_class.new.(input) }
  let(:input) { { params: ActionController::Parameters.new(params) } }

  context 'valid params' do
    let(:params) { attributes_for(:user) }
    let!(:user) { create(:user, params) }

    it { is_expected.to be_success }
    it { expect(result.success[:model]).to_not be_nil }
    it { expect(result.success[:token]).to_not be_nil }
    it { expect(result.success[:expire]).to_not be_nil }
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

    context 'user does not exist' do
      let(:params) { attributes_for(:user) }

      it { expect(result.failure[:email]).to eq(['Wrong email or password']) }
    end

    context 'missing password' do
      let(:params) { attributes_for(:user).merge(password: '') }

      it { expect(result.failure[:password]).to eq(['must be filled']) }
    end

    context 'invalid password' do
      let(:params) { attributes_for(:user).merge(password: 'qwerty') }
      let!(:user) { create(:user, email: params[:email]) }

      it { expect(result.failure[:email]).to eq(['Wrong email or password']) }
    end
  end
end
