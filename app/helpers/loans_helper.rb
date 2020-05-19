# frozen_string_literal: true

module LoansHelper
  def loan_float_fields
    ['loan_borrowed_amount', 'loan_received_amount']
  end

  def loans_title(loan_status)
    "Empréstimos#{build_status(loan_status)}"
  end

  private

  def build_status(loan_status)
    case loan_status
    when :open
      ' em Aberto'
    when :received
      ' fechados'
    else
      'body_else'
    end
  end
end
