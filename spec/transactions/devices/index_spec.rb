require 'rails_helper'

RSpec.describe Transactions::Devices::Index do
  subject(:result) { described_class.new.(input) }
  let(:input) { { user: user } }
  let!(:user) { create(:user) }
  let(:matcher) {
    proc { |m|
      m.success do
        'success'
      end

      m.failure :policy do
        'policy'
      end

      m.failure :find_devices do
        'find_devices'
      end
    }
  }

  context 'missing user' do
    let(:user) { nil }
    subject(:operation) { described_class.new }

    it { expect(operation.call(input, &matcher)).to eq('policy') }
  end

  context 'existing user' do
    let!(:device) { create(:device, user: user) }
    let!(:other_device) { create(:device) }

    it { is_expected.to be_success }
    it { expect(result.success[:data]).to include(device) }
    it { expect(result.success[:data]).not_to include(other_device) }
  end
end
