# frozen_string_literal: true

class LoansController < ApplicationController
  include I18nBasePath
  include CreateAction

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
    if @loan.update(loan_params)
      redirect_to(loans_path, notice: t("#{i18n_base_path}.updated"))
    else
      render(:show)
    end
  end

  # DELETE /loans/1
  def destroy
    @loan.destroy
    redirect_to(loans_url, notice: t("#{i18n_base_path}.removed"))
  end

  private

  def set_loan
    @loan = Loan.find_by(id: params[:id], user: current_user)
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
    return Time.zone.today.to_s if params[:received_at].blank?

    params[:received_at]
  end
end
