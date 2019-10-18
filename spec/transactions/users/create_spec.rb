require 'rails_helper'

RSpec.describe Transactions::Users::Create do
  subject(:result) { described_class.new.(data) }
  let(:input) { { params: params } }

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

      it { is_expected.to have_errors_on(email: :key?) }
    end

    context 'missing email' do
      let(:params) { attributes_for(:user).merge(email: '') }

      it { is_expected.to have_errors_on(email: :filled?) }
    end

    context 'duplicate email' do
      let!(:user) { create(:user) }
      let(:params) { attributes_for(:user).merge(email: user.email) }

      it { is_expected.to have_errors_on(email: :unique?) }
    end

    context 'missing password' do
      let(:params) { attributes_for(:user).merge(password: '') }

      it { is_expected.to have_errors_on(password: :filled?) }
    end

    context 'short password' do
      let(:params) { attributes_for(:user).merge(password: 'qwerty') }

      it { is_expected.to have_errors_on(password: :too_short?) }
    end
  end
end
