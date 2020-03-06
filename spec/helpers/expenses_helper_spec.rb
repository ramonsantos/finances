# frozen_string_literal: true

require 'rails_helper'

describe ExpensesHelper, type: :helper do
  let(:expense) { create(:expense) }

  describe '.formated_percent' do
    context 'when value blank' do
      it 'returns blank value' do
        expect(helper.formated_percent(nil)).to eq('0,00')
      end
    end

    context 'when value present' do
      it 'returns formated value' do
        expect(helper.formated_percent(1.1)).to eq('1,10')
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
      expect(month_label(:prev, Time.zone.today)).to eq('Dez/2019')
    end

    it 'returns current label' do
      expect(month_label(:current, Time.zone.today)).to eq('Jan/2020')
    end

    it 'returns next label' do
      expect(month_label(:next, Time.zone.today)).to eq('Fev/2020')
    end
  end

  describe '.month_param' do
    before { Timecop.freeze(2020, 1, 31) }

    after { Timecop.return }

    it 'returns prev date param' do
      expect(month_param(Time.zone.today, :prev)).to eq('2019-12-31')
    end

    it 'returns current date param' do
      expect(month_param(Time.zone.today, :current)).to eq('2020-01-31')
      expect(month_param(Time.zone.today)).to eq('2020-01-31')
    end

    it 'returns next date param' do
      expect(month_param(Time.zone.today, :next)).to eq('2020-02-29')
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
