# frozen_string_literal: true

require 'rails_helper'

describe Loan, type: :model do
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
        it { is_expected.not_to validate_presence_of(:estimated_receipt_at) }
        it { is_expected.not_to validate_presence_of(:expected_amount_to_receive) }
        it { is_expected.not_to validate_presence_of(:received_amount) }
        it { is_expected.not_to validate_presence_of(:received_at) }
      end
    end
  end

  describe 'scopes' do
    before do
      create(:loan)
      create(:loan, loan_date: Date.parse('2020-03-15'))
    end

    describe '.fetch_order_by_loan_date' do
      let(:loans) { described_class.fetch_order_by_loan_date(User.first) }

      it 'returns loans' do
        expect(loans.count).to eq(2)
        expect(loans.first.loan_date).to eq(Date.parse('2020-03-06'))
        expect(loans.last.loan_date).to eq(Date.parse('2020-03-15'))
      end
    end
  end
end
