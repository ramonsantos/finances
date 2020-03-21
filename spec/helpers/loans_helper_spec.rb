# frozen_string_literal: true

require 'rails_helper'

describe LoansHelper, type: :helper do
  describe '.loan_float_fields' do
    let(:expected_result) { ['loan_borrowed_amount', 'loan_expected_amount_to_receive', 'loan_received_amount'] }

    it { expect(loan_float_fields).to eq(expected_result) }
  end
end
