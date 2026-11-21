# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#btn_primary' do
    let(:expected_result) { ApplicationHelper::BTN_PRIMARY }

    it 'returns the primary button class string' do
      expect(helper.btn_primary).to eq(expected_result)
    end
  end

  describe '#btn_primary_sm' do
    let(:expected_result) { ApplicationHelper::BTN_PRIMARY_SM }

    it 'returns the small primary button class string' do
      expect(helper.btn_primary_sm).to eq(expected_result)
    end
  end

  describe '#btn_primary_xs' do
    let(:expected_result) { ApplicationHelper::BTN_PRIMARY_XS }

    it 'returns the extra-small primary button class string' do
      expect(helper.btn_primary_xs).to eq(expected_result)
    end
  end

  describe '#btn_outline' do
    let(:expected_result) { ApplicationHelper::BTN_OUTLINE }

    it 'returns the outline button class string' do
      expect(helper.btn_outline).to eq(expected_result)
    end
  end

  describe '#btn_danger_xs' do
    let(:expected_result) { ApplicationHelper::BTN_DANGER_XS }

    it 'returns the extra-small danger button class string' do
      expect(helper.btn_danger_xs).to eq(expected_result)
    end
  end

  describe '#input_class' do
    let(:expected_result) do
      'mt-1 block w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm ' \
        'focus:border-sky-500 focus:outline-none focus:ring-1 focus:ring-sky-500'
    end

    it 'returns the input field class string' do
      expect(helper.input_class).to eq(expected_result)
    end
  end

  describe '#label_class' do
    let(:expected_result) { 'block text-sm font-medium text-slate-700' }

    it 'returns the label class string' do
      expect(helper.label_class).to eq(expected_result)
    end
  end

  describe '#current_year' do
    let(:frozen_date) { Date.new(2025, 8, 20) }
    let(:expected_result) { 2025 }

    it 'returns the current year in the application time zone' do
      Timecop.freeze(frozen_date) do
        expect(helper.current_year).to eq(expected_result)
      end
    end
  end

  describe '#formatted_money' do
    context 'when value is present' do
      let(:expected_result) { 'R$ 10,50' }

      it 'formats the amount as currency' do
        expect(helper.formatted_money(10.5)).to eq(expected_result)
      end
    end

    context 'when value is blank' do
      let(:expected_result) { '' }

      it 'returns an empty string' do
        expect(helper.formatted_money(nil)).to eq(expected_result)
        expect(helper.formatted_money('')).to eq(expected_result)
      end
    end
  end

  describe '#form_amount_value' do
    context 'when value is present' do
      let(:expected_result) { '10.50' }

      it 'formats the amount with two decimal places' do
        expect(helper.form_amount_value(10.5)).to eq(expected_result)
      end
    end

    context 'when value is blank' do
      let(:expected_result) { '' }

      it 'returns an empty string' do
        expect(helper.form_amount_value(nil)).to eq(expected_result)
        expect(helper.form_amount_value('')).to eq(expected_result)
      end
    end
  end

  describe '#expense_month_label' do
    let(:date) { Date.new(2025, 3, 15) }

    context 'when offset is current' do
      let(:expected_result) { 'Mar/2025' }

      it 'returns the abbreviated month and year' do
        expect(helper.expense_month_label(date, :current)).to eq(expected_result)
      end
    end

    context 'when offset is prev' do
      let(:expected_result) { 'Fev/2025' }

      it 'returns the previous month label' do
        expect(helper.expense_month_label(date, :prev)).to eq(expected_result)
      end
    end

    context 'when offset is next' do
      let(:expected_result) { 'Abr/2025' }

      it 'returns the next month label' do
        expect(helper.expense_month_label(date, :next)).to eq(expected_result)
      end
    end
  end

  describe '#expense_month_param' do
    let(:date) { Date.new(2025, 3, 15) }

    context 'when offset is current' do
      let(:expected_result) { '2025-03-15' }

      it 'returns the month date as a string' do
        expect(helper.expense_month_param(date, :current)).to eq(expected_result)
      end
    end

    context 'when offset is prev' do
      let(:expected_result) { '2025-02-15' }

      it 'returns the previous month date as a string' do
        expect(helper.expense_month_param(date, :prev)).to eq(expected_result)
      end
    end
  end

  describe '#parse_expense_month' do
    let(:frozen_date) { Date.new(2025, 5, 10) }

    context 'when param is a valid date string' do
      let(:param) { '2025-01-20' }
      let(:expected_result) { Date.new(2025, 1, 20) }

      it 'parses the date' do
        expect(helper.parse_expense_month(param)).to eq(expected_result)
      end
    end

    context 'when param is blank' do
      let(:param) { '' }
      let(:expected_result) { frozen_date }

      it 'returns today in the application time zone' do
        Timecop.freeze(frozen_date) do
          expect(helper.parse_expense_month(param)).to eq(expected_result)
        end
      end
    end

    context 'when param is invalid' do
      let(:param) { 'invalid' }
      let(:expected_result) { frozen_date }

      it 'returns today in the application time zone' do
        Timecop.freeze(frozen_date) do
          expect(helper.parse_expense_month(param)).to eq(expected_result)
        end
      end
    end
  end

  describe '#remark_preview' do
    context 'when remark is nil' do
      let(:expected_result) { nil }

      it 'returns nil' do
        expect(helper.remark_preview(nil)).to eq(expected_result)
      end
    end

    context 'when remark is an empty string' do
      let(:expected_result) { '' }

      it 'returns an empty string' do
        expect(helper.remark_preview('')).to eq(expected_result)
      end
    end

    context 'when remark has at most thirty characters' do
      let(:remark) { 'Observação curta' }
      let(:expected_result) { 'Observação curta' }

      it 'returns the full remark' do
        expect(helper.remark_preview(remark)).to eq(expected_result)
      end
    end

    context 'when remark is longer than thirty characters' do
      let(:remark) { 'a' * 31 }
      let(:expected_result) { "#{'a' * 27}..." }

      it 'truncates the remark with an ellipsis' do
        expect(helper.remark_preview(remark)).to eq(expected_result)
      end
    end
  end

  describe '#fixed_badge' do
    context 'when expense is fixed' do
      let(:expected_result) { 'Sim' }

      it 'returns the fixed label' do
        expect(helper.fixed_badge(true)).to eq(expected_result)
      end
    end

    context 'when expense is not fixed' do
      let(:expected_result) { 'Não' }

      it 'returns the non-fixed label' do
        expect(helper.fixed_badge(false)).to eq(expected_result)
      end
    end
  end

  describe '#loans_title' do
    context 'when status is open' do
      let(:expected_result) { 'em aberto' }

      it 'returns the open loans title' do
        expect(helper.loans_title(:open)).to eq(expected_result)
      end
    end

    context 'when status is received' do
      let(:expected_result) { 'recebidos' }

      it 'returns the received loans title' do
        expect(helper.loans_title(:received)).to eq(expected_result)
      end
    end
  end

  describe '#pagy_nav' do
    context 'when there is a single page' do
      let(:pagy) { instance_double(Pagy::Offset, pages: 1) }
      let(:expected_result) { '' }

      it 'returns an empty string' do
        expect(helper.pagy_nav(pagy)).to eq(expected_result)
      end
    end

    context 'when there are multiple pages' do
      let(:pagy) { instance_double(Pagy::Offset, pages: 3) }
      let(:expected_result) { '<nav id="pagination" class="pagy-nav"></nav>' }

      before do
        allow(pagy).to receive(:series_nav).with(
          id: 'pagination',
          aria_label: 'Páginas',
          class: 'pagy-nav'
        ).and_return(expected_result)
      end

      it 'delegates to pagy series_nav' do
        expect(helper.pagy_nav(pagy)).to eq(expected_result)
      end
    end
  end
end
