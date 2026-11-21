# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoansIndexService do
  describe '.call' do
    context 'when success' do
      context 'when listing open loans' do
        let(:loan_status_param) { 'to_receive' }
        let!(:open_loan) { create(:loan, received_amount: nil) }
        let(:expected_loan_status) { :to_receive }
        let(:expected_next_loan_status) { :received }

        before { create(:loan, received_amount: 50, received_at: Time.zone.today) }

        it 'returns scope, totals and navigation metadata for open loans' do
          result = described_class.call(loan_status_param: loan_status_param)

          expect(result[:loan_status]).to eq(expected_loan_status)
          expect(result[:next_loan_status]).to eq(expected_next_loan_status)
          expect(result[:scope]).to eq([open_loan])
          expect(result[:amount_of_loans_to_receive]).to eq(open_loan.borrowed_amount)
        end
      end

      context 'when listing received loans' do
        let(:loan_status_param) { 'received' }
        let!(:received_loan) { create(:loan, received_amount: 80, received_at: Time.zone.today) }
        let(:expected_loan_status) { :received }
        let(:expected_next_loan_status) { :to_receive }
        let(:expected_amount_to_receive) { 40.0 }

        before { create(:loan, received_amount: nil, borrowed_amount: 40) }

        it 'returns scope, totals and navigation metadata for received loans' do
          result = described_class.call(loan_status_param: loan_status_param)

          expect(result[:loan_status]).to eq(expected_loan_status)
          expect(result[:next_loan_status]).to eq(expected_next_loan_status)
          expect(result[:scope]).to eq([received_loan])
          expect(result[:amount_of_loans_to_receive]).to eq(expected_amount_to_receive)
        end
      end

      context 'when loan_status param is omitted' do
        let(:loan_status_param) { nil }
        let(:expected_loan_status) { :to_receive }

        it 'defaults to open loans' do
          result = described_class.call(loan_status_param: loan_status_param)

          expect(result[:loan_status]).to eq(expected_loan_status)
        end
      end
    end
  end
end
