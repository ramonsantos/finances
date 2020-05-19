# frozen_string_literal: true

require 'rails_helper'

describe Loan, type: :model do
  let(:user) { User.first }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    context 'when presense_of' do
      context 'when true' do
        it { is_expected.to validate_presence_of(:person) }
        it { is_expected.to validate_presence_of(:description) }
        it { is_expected.to validate_presence_of(:borrowed_amount) }
        it { is_expected.to validate_presence_of(:loan_date) }
        it { is_expected.to validate_presence_of(:user) }
      end

      context 'when false' do
        it { is_expected.not_to validate_presence_of(:received_amount) }
        it { is_expected.not_to validate_presence_of(:received_at) }
      end
    end
  end

  describe 'scopes' do
    before do
      create(:loan)
      create(:loan, loan_date: Date.parse('2020-03-15'), borrowed_amount: 52.62)
      create(:loan, loan_date: Date.parse('2020-03-15'), received_amount: 110.0)
    end

    describe '.open' do
      let(:loans) { described_class.open(user) }

      it 'returns loans' do
        expect(loans.count).to eq(2)
        expect(loans.first.loan_date).to eq(Date.parse('2020-03-06'))
        expect(loans.last.loan_date).to eq(Date.parse('2020-03-15'))
      end
    end

    describe '.received' do
      let(:loans) { described_class.received(user) }

      it 'returns loans' do
        expect(loans.count).to eq(1)
        expect(loans.first.loan_date).to eq(Date.parse('2020-03-15'))
      end
    end

    describe '.amount_of_loans_to_receive' do
      let(:amount) { described_class.amount_of_loans_to_receive(user) }

      it 'returns amount of loans to receive' do
        expect(amount).to eq(153.12)
      end
    end
  end
end
