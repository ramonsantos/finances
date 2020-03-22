# frozen_string_literal: true

class LoansController < ApplicationController
  before_action :set_loan, only: [:show, :update, :destroy]

  # GET /loans
  # GET /loans.json
  def index
    @loans = Loan.fetch_order_by_loan_date(current_user).page(params[:page])
  end

  # GET /loans/1
  # GET /loans/1.json
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new
  end

  # POST /loans
  # POST /loans.json
  def create
    @loan = Loan.new(loan_params.merge!(user: current_user))

    respond_to do |format|
      if @loan.save
        format.html { redirect_to loans_path, notice: 'Empréstimo adicionado.' }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loans/1
  # PATCH/PUT /loans/1.json
  def update
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to loans_path, notice: 'Empréstimo atualizado.' }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :show }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    @loan.destroy
    respond_to do |format|
      format.html { redirect_to loans_url, notice: 'Empréstimo removido.' }
      format.json { head :no_content }
    end
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
      :estimated_receipt_at,
      :received_at,
      :borrowed_amount,
      :expected_amount_to_receive,
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
