# frozen_string_literal: true

class LoansIndexService < ApplicationService
  def initialize(loan_status_param:)
    super()
    @loan_status_param = loan_status_param
  end

  private

  def call
    {
      loan_status: loan_status,
      scope: loans_scope,
      amount_of_loans_to_receive: Loan.amount_to_receive,
      next_loan_status: next_loan_status
    }
  end

  attr_reader :loan_status_param

  def loan_status
    loan_status_param.to_s == "received" ? :received : :to_receive
  end

  def loans_scope
    scope = loan_status == :received ? Loan.received : Loan.to_receive
    scope.order(:loan_date)
  end

  def next_loan_status
    loan_status == :received ? :to_receive : :received
  end
end