# frozen_string_literal: true

require 'rails_helper'

describe ExpensesHelper, type: :helper do
  let(:expense) { create(:expense) }

  describe '.only_numbers_script' do
    it 'returns script' do
      expect(helper.only_numbers_script).to eq("this.value=this.value.replace(/[^0-9]/g,'');")
    end
  end

  describe '.normalize_amount' do
    it 'returns script' do
      expect(helper.normalize_amount).to eq(
        'var expenseAmountElement = document.getElementById("expense_amount");' \
        'expenseAmountElement.value = expenseAmountElement.value.replace(/[R][$][ ]/, "").replace(",", ".")'
      )
    end
  end

  describe '.formated_amount' do
    context 'when amount blank' do
      it 'returns blank value' do
        expect(helper.formated_amount(nil)).to eq('')
      end
    end

    context 'when amount present' do
      it 'returns formated value' do
        expect(helper.formated_amount(1.1)).to eq('R$ 1,10')
      end
    end
  end

  describe '.expense_date' do
    context 'when expense with date' do
      it 'returns expense date' do
        expect(expense_date(expense)).to eq('2020-02-15')
      end
    end

    context 'when expense without date' do
      before do
        Timecop.freeze(2020, 2, 20)
        expense.date = nil
      end

      after { Timecop.return }

      it 'returns current date' do
        expect(expense_date(expense)).to eq('2020-02-20')
      end
    end
  end

  describe '.current_option' do
    context 'when place' do
      context 'when expense current option' do
        it 'returns expense place id' do
          expect(current_option(expense, :place_id, [])).to eq(expense.place_id)
        end
      end

      context 'when first option' do
        let(:first_place) { create(:place) }
        let(:last_place) { create(:place_surubim) }

        let(:places) do
          [
            [first_place.name, first_place.id],
            [last_place.name, last_place.id]
          ]
        end

        before { expense.place = nil }

        it 'returns first place id' do
          expect(current_option(expense, :place_id, places)).to eq(first_place.id)
        end
      end
    end

    context 'when expense_group' do
      context 'when expense current option' do
        it 'returns expense place id' do
          expect(current_option(expense, :place_id, [])).to eq(expense.place_id)
        end
      end

      context 'when first option' do
        let(:first_expense_group) { create(:expense_group) }
        let(:last_expense_group) { create(:expense_group_home) }

        let(:expense_groups) do
          [
            [first_expense_group.name, first_expense_group.id],
            [last_expense_group.name, last_expense_group.id]
          ]
        end

        before { expense.expense_group = nil }

        it 'returns first place id' do
          expect(current_option(expense, :expense_group_id, expense_groups)).to eq(first_expense_group.id)
        end
      end
    end
  end

  describe '.month_label' do
    before { Timecop.freeze(2020, 1, 20) }

    after { Timecop.return }

    it 'returns prev label' do
      expect(month_label(:prev)).to eq('Dez/2019')
    end

    it 'returns current label' do
      expect(month_label(:current)).to eq('Jan/2020')
    end

    it 'returns next label' do
      expect(month_label(:next)).to eq('Fev/2020')
    end
  end

  describe '.fixed_label' do
    it 'returns "Sim" label' do
      expect(fixed_label(true)).to eq('Sim')
    end

    it 'returns "Não" label' do
      expect(fixed_label(false)).to eq('Não')
    end
  end

  describe '.format_to_money' do
    it { expect(format_to_money(0.1)).to eq('0,10 R$') }
    it { expect(format_to_money(1.01)).to eq('1,01 R$') }
    it { expect(format_to_money(1012.1)).to eq('1.012,10 R$') }
  end

  describe '.format_date' do
    it 'returns formated date' do
      expect(format_date(expense.date)).to eq('15/02/2020')
    end
  end

  describe '.remark_preview' do
    context 'when remark is blank' do
      it { expect(remark_preview('')).to eq('') }
    end

    context 'when remark less than or equal to 20' do
      it { expect(remark_preview('12345678901234567890')).to eq('12345678901234567890') }
    end

    context 'when remark greater than 20' do
      it { expect(remark_preview('123456789012345678901')).to eq('12345678901234567...') }
    end
  end
end
