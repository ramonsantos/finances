# frozen_string_literal: true

class LoansController < ApplicationController
  include ResourceResponses

  before_action :set_loan, only: [:show, :update, :destroy]

  def index
    index_data = LoansIndexService.call(loan_status_param: params[:loan_status])

    @loan_status = index_data[:loan_status]
    @amount_of_loans_to_receive = index_data[:amount_of_loans_to_receive]
    @next_loan_status = index_data[:next_loan_status]
    @pagy, @loans = pagy(:offset, index_data[:scope])
  end

  def show; end

  def new
    @loan = Loan.new(loan_date: Time.zone.today)
  end

  def create
    @loan = Loan.new(loan_params)
    create_resource(@loan, loans_path)
  end

  def update
    update_resource(@loan, loan_params, loan_path(@loan))
  end

  def destroy
    destroy_resource(@loan, loans_path(loan_status: @loan.received_amount.present? ? :received : :to_receive))
  end

  private

  def set_loan
    @loan = Loan.find(params.expect(:id))
  end

  def loan_params
    params.expect(
      loan: [
        :description,
        :loan_date,
        :received_at,
        :borrowed_amount,
        :person,
        :received_amount
      ]
    )
  end
end
