# frozen_string_literal: true

module LoansHelper
  def loan_float_fields
    ['loan_borrowed_amount', 'loan_received_amount']
  end

  def loans_title(loan_status)
    status = loan_status == :received ? :closed : :open
    build_loans_title(status)
  end

  private

  def build_loans_title(status)
    t("helpers.loans.#{status}")
  end
end
