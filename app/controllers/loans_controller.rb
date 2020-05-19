# frozen_string_literal: true

class LoansController < ApplicationController
  include CreateAction

  before_action :set_loan, only: [:show, :update, :destroy]

  # GET /loans
  def index
    @loans = Loan.fetch_order_by_loan_date(current_user, {}).page(params[:page])
    @amount_of_loans_to_receive = Loan.fetch_amount_of_loans_to_receive(current_user)
    @loan_status = :open
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

    create_action(@loan, loans_path, 'Empréstimo adicionado.')
  end

  # PATCH/PUT /loans/1
  def update
    if @loan.update(loan_params)
      redirect_to(loans_path, notice: 'Empréstimo atualizado.')
    else
      render(:show)
    end
  end

  # DELETE /loans/1
  def destroy
    @loan.destroy
    redirect_to(loans_url, notice: 'Empréstimo removido.')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_loan
    @loan = Loan.find_by(id: params[:id], user: current_user)
  end

  # Only allow a list of trusted parameters through.
  def loan_params
    params.require(:loan).permit(
      :description,
      :loan_date,
      :received_at,
      :borrowed_amount,
      :person,
      :received_amount
    ).tap do |hash|
      if hash[:received_amount].blank?
        hash[:received_at] = nil
      else
        hash[:received_at] ||= Time.zone.today.to_s
      end
    end
  end
end
