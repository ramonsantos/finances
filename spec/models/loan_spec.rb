# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe 'validations' do
    context 'when validate presence_of' do
      it do
        expect(subject).to validate_presence_of(:person)
        expect(subject).to validate_presence_of(:description)
        expect(subject).to validate_presence_of(:borrowed_amount)
        expect(subject).to validate_presence_of(:loan_date)
      end
    end

    context 'when validate numericality_of' do
      it { is_expected.to validate_numericality_of(:borrowed_amount).is_greater_than_or_equal_to(0.01) }
    end

    context 'when custom validators' do
      let(:loan) { build(:loan) }

      context 'when success' do
        context 'when received amount is set without received_at' do
          let(:received_at) { Date.new(2025, 6, 10) }

          it 'sets received_at to today' do
            Timecop.freeze(received_at) do
              loan.received_amount = 50
              loan.valid?

              expect(loan.received_at).to eq(received_at)
            end
          end
        end
      end

      context 'when error' do
        context 'when received_at is set without received_amount' do
          let(:expected_result) { ['não é válido'] }

          it 'adds received_at error' do
            loan.received_at = Date.new(2025, 1, 1)
            loan.validate

            expect(loan.errors[:received_at]).to eq(expected_result)
          end
        end
      end
    end
  end

  describe '.to_receive' do
    let!(:open_loan) { create(:loan, received_amount: nil) }
    let(:expected_result) { [open_loan] }

    before { create(:loan, received_amount: 10, received_at: Time.zone.today) }

    it 'returns loans without received amount' do
      expect(described_class.to_receive).to match_array(expected_result)
    end
  end

  describe '.received' do
    let!(:closed_loan) { create(:loan, received_amount: 80, received_at: Time.zone.today) }
    let(:expected_result) { [closed_loan] }

    before { create(:loan, received_amount: nil) }

    it 'returns loans with received amount' do
      expect(described_class.received).to match_array(expected_result)
    end
  end

  describe '.amount_to_receive' do
    let(:expected_result) { 150.0 }

    before do
      create(:loan, borrowed_amount: 100, received_amount: nil)
      create(:loan, borrowed_amount: 50, received_amount: nil)
      create(:loan, borrowed_amount: 999, received_amount: 10, received_at: Time.zone.today)
    end

    it 'sums borrowed amounts for open loans' do
      expect(described_class.amount_to_receive).to eq(expected_result)
    end
  end
end
