# frozen_string_literal: true

class LoansController < ApplicationController
  include I18nBasePath
  include CreateAction
  include UpdateAction
  include DestroyAction

  before_action :set_loan, only: [:destroy, :show, :update]

  # GET /loans
  def index
    @loans = Loan.send(loan_status, current_user).order(:loan_date).page(params[:page])
    @amount_of_loans_to_receive = Loan.amount_of_loans_to_receive(current_user)
    @params_to_toggle_loan_status = { loan_status: next_loan_status }
  end

  # GET /loans/1
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new
  end

  # POST /loans
  def create
    @loan = Loan.new(loan_params.merge!(user: current_user))

    create_action(@loan, loans_path)
  end

  # PATCH/PUT /loans/1
  def update
    update_action(@loan, loan_params, loans_path)
  end

  # DELETE /loans/1
  def destroy
    destroy_action(@loan, loans_path)
  end

  private

  def set_loan
    @loan = current_user.loans.find(params[:id])
  end

  def loan_status
    @loan_status ||= (params[:loan_status].try(:to_sym) || :to_receive)
  end

  def next_loan_status
    { to_receive: :received, received: :to_receive }[loan_status]
  end

  def loan_params
    params.require(:loan).permit(
      :description,
      :loan_date,
      :received_at,
      :borrowed_amount,
      :person,
      :received_amount
    ).tap do |hash|
      hash[:received_at] = received_at_value(hash)
    end
  end

  def received_at_value(params)
    return nil if params[:received_amount].blank?

    params[:received_at].presence || Time.zone.today.to_s
  end
end
