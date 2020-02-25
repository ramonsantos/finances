# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :set_expense,    only: [:edit, :destroy, :show, :update]
  before_action :places,         only: [:edit, :new]
  before_action :expense_groups, only: [:edit, :new]

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.fetch_by_month(current_user, expense_month).page(params[:page])
    @current_expense_month = expense_month
    @total_expense_amount = Expense.fetch_total_monthly_spend(current_user, expense_month)
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user

    respond_to do |format|
      if @expense.save
        format.html { redirect_to expenses_path, notice: 'Despesa adicionada.' }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to expenses_path, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_path(expense_month: expense_month), notice: 'Despesa removida.' }
      format.json { head :no_content }
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:description, :amount, :date, :fixed, :remark, :category, :expense_group_id, :place_id)
  end

  def places
    @places ||= fetch_places
  end

  def fetch_places
    Place.where(user: current_user).pluck(:name, :id)
  end

  def expense_groups
    @expense_groups ||= fetch_expense_groups
  end

  def fetch_expense_groups
    ExpenseGroup.where(user: current_user).pluck(:name, :id)
  end

  def expense_month
    return Time.zone.today if params[:expense_month].blank?

    Date.parse(params[:expense_month])
  end
end
