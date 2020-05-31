# frozen_string_literal: true

require 'rails_helper'

describe LoansHelper, type: :helper do
  describe '.loan_float_fields' do
    let(:expected_result) { ['loan_borrowed_amount', 'loan_received_amount'] }

    it { expect(loan_float_fields).to eq(expected_result) }
  end

  describe '.loans_title' do
    context 'when loan_status is :to_receive' do
      let(:expected_result) { 'Empréstimos em Aberto' }

      it { expect(loans_title(:to_receive)).to eq(expected_result) }
    end

    context 'when loan_status is :received' do
      let(:expected_result) { 'Empréstimos fechados' }

      it { expect(loans_title(:received)).to eq(expected_result) }
    end
  end
end
