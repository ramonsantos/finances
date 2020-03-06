# frozen_string_literal: true

require 'rails_helper'

describe LoansHelper, type: :helper do
  describe '.loan_float_fields' do
    it { expect(loan_float_fields).to eq(['borrowed_amount', 'expected_amount_to_receive', 'received_amount']) }
  end
end
