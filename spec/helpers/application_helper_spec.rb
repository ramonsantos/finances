# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '.only_numbers_script' do
    it 'returns script' do
      expect(helper.only_numbers_script).to eq("this.value=this.value.replace(/[^0-9]/g,'');")
    end
  end

  describe '.formated_float_value' do
    context 'when value blank' do
      it 'returns blank value' do
        expect(helper.formated_float_value(nil)).to eq('')
      end
    end

    context 'when value present' do
      it 'returns formated value' do
        expect(helper.formated_float_value(1.1)).to eq('R$ 1,10')
      end
    end
  end

  describe '.format_to_money' do
    it { expect(format_to_money(0.1)).to eq('0,10 R$') }
    it { expect(format_to_money(1.01)).to eq('1,01 R$') }
    it { expect(format_to_money(1012.1)).to eq('1.012,10 R$') }
  end

  describe '.format_date' do
    it { expect(format_date(Date.parse('2020-02-15'))).to eq('15/02/2020') }
    it { expect(format_date(nil)).to eq('') }
  end

  describe '.date_field' do
    context 'with present' do
      it 'returns date' do
        expect(date_field(Date.parse('2020-02-15'))).to eq('2020-02-15')
      end
    end

    context 'without date but with "use_current_time_when_date_blank"' do
      before { Timecop.freeze(2020, 2, 20) }

      after { Timecop.return }

      it 'returns current date' do
        expect(date_field(nil)).to eq('2020-02-20')
      end
    end

    context 'without date and and "use_current_time_when_date_blank"' do
      it 'returns current date' do
        expect(date_field(nil, false)).to eq('')
      end
    end
  end

  describe '.current_year' do
    before { Timecop.freeze(2019, 6, 6) }

    after { Timecop.return }

    it 'returns current year' do
      expect(current_year).to eq('2019')
    end
  end

  describe '.normalize_float_value' do
    it 'returns script' do
      expect(helper.normalize_float_value('expense_amount')).to eq(
        'var expenseAmountElement = document.getElementById("expense_amount");' \
        'expenseAmountElement.value = expenseAmountElement.value.replace(/[R][$][ ]/, "").replace(",", ".");'
      )
    end
  end

  describe '.normalize_float_values' do
    it 'returns script' do
      expect(helper.normalize_float_values(['borrowed_amount', 'received_amount'])).to eq(
        'var borrowedAmountElement = document.getElementById("borrowed_amount");' \
        'borrowedAmountElement.value = borrowedAmountElement.value.replace(/[R][$][ ]/, "").replace(",", ".");' \
        'var receivedAmountElement = document.getElementById("received_amount");' \
        'receivedAmountElement.value = receivedAmountElement.value.replace(/[R][$][ ]/, "").replace(",", ".");'
      )
    end
  end

  describe '.validation_class' do
    context 'with error' do
      let(:fields_validation) do
        {
          password_confirmation: {
            status: :error,
            message: 'não é igual a Senha'
          }
        }
      end

      it { expect(validation_class(fields_validation, :password_confirmation)).to eq(' is-invalid') }
    end

    context 'without erro' do
      let(:fields_validation) { {} }

      it { expect(validation_class(fields_validation, :password_confirmation)).to be_nil }
    end
  end
end
