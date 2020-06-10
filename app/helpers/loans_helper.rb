# frozen_string_literal: true

module LoansHelper
  def loan_float_fields
    ['loan_borrowed_amount', 'loan_received_amount']
  end

  def loans_title(loan_status)
    loan_status == :received ? 'fechados' : 'em Aberto'
  end
end
