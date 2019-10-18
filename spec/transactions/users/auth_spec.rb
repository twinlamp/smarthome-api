require 'rails_helper'

RSpec.describe Transactions::Users::Auth do
  subject(:result) { described_class.new.(data) }
  let(:input) { { params: params } }

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

      it { is_expected.to have_errors_on(email: :key?) }
    end

    context 'missing email' do
      let(:params) { attributes_for(:user).merge(email: '') }

      it { is_expected.to have_errors_on(email: :filled?) }
    end

    context 'user does not exist' do
      let(:params) { attributes_for(:user) }

      it { is_expected.to have_errors_on(email: :wrong?) }
    end

    context 'missing password' do
      let(:params) { attributes_for(:user).merge(password: '') }

      it { is_expected.to have_errors_on(password: :filled?) }
    end

    context 'invalid password' do
      let(:params) { attributes_for(:user).merge(password: 'qwerty') }
      let!(:user) { create(:user, email: params[:email]) }

      it { is_expected.to have_errors_on(email: :wrong?) }
    end
  end
end
