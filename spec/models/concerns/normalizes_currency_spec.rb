# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NormalizesCurrency do
  let(:model_class) do
    Class.new(ApplicationRecord) do
      self.table_name = 'expenses'
      include NormalizesCurrency

      normalizes_currency :amount
      normalizes_currency :remark
    end
  end

  describe '.normalizes_currency' do
    context 'when success' do
      context 'when value is already numeric' do
        let(:expected_result) { 15.75 }

        it 'keeps the numeric value' do
          record = model_class.new(amount: expected_result)

          expect(record.amount).to eq(expected_result)
        end
      end

      context 'when value uses comma as decimal separator' do
        let(:expected_result) { BigDecimal('10.5') }

        it 'normalizes the string into a decimal' do
          record = model_class.new(remark: '10,50')

          expect(record.remark).to eq(expected_result)
        end
      end

      context 'when value includes currency symbols and thousands separators' do
        let(:expected_result) { BigDecimal('1234.56') }

        it 'strips formatting characters before parsing' do
          record = model_class.new(remark: 'R$ 1.234,56')

          expect(record.remark).to eq(expected_result)
        end
      end
    end

    context 'when error' do
      context 'when value is blank' do
        let(:expected_result) { nil }

        it 'does not normalize nil' do
          record = model_class.new(amount: nil)

          expect(record.amount).to eq(expected_result)
        end
      end
    end
  end
end
