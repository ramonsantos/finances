# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoanReceivedAtRequiresAmountValidator do
  describe '#validate' do
    context 'when success' do
      context 'when received_at is blank' do
        let(:loan) { build(:loan, received_at: nil, received_amount: nil) }
        let(:expected_result) { [] }

        it 'does not add received_at errors' do
          described_class.new.validate(loan)

          expect(loan.errors[:received_at]).to eq(expected_result)
        end
      end

      context 'when received amount is present' do
        let(:loan) { build(:loan, received_at: Date.new(2025, 1, 1), received_amount: 50) }
        let(:expected_result) { [] }

        it 'does not add received_at errors' do
          described_class.new.validate(loan)

          expect(loan.errors[:received_at]).to eq(expected_result)
        end
      end
    end

    context 'when error' do
      context 'when received_at is set without received_amount' do
        let(:loan) { build(:loan, received_at: Date.new(2025, 1, 1), received_amount: nil) }
        let(:expected_result) { ['não é válido'] }

        it 'adds received_at error' do
          described_class.new.validate(loan)

          expect(loan.errors[:received_at]).to eq(expected_result)
        end
      end
    end
  end
end
