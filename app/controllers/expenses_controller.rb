# frozen_string_literal: true

class ExpensesController < ApplicationController
  include CreateAction

  before_action :set_expense,        only: [:destroy, :show, :update]
  before_action :places,             only: [:new, :show]
  before_action :expense_groups,     only: [:new, :show]
  before_action :expense_categories, only: [:new, :show]

  # GET /expenses
  def index
    @expenses = Expense.fetch_by_month(current_user, expense_month).page(params[:page])
    @current_expense_month = expense_month
    @total_expense_amount = Expense.fetch_total_monthly_spend(current_user, expense_month)
  end

  # GET /expenses/report
  def report
    @current_expense_month = expense_month
    @expenses_grouped_data = Expense.group_for_report(current_user, expense_month)
  end

  # GET /expenses/1
  def show
    @current_expense_month = expense_month
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/new_from_csv
  def new_from_csv
    @results = {}
  end

  # POST /expenses
  def create
    @expense = Expense.new(expense_params.merge!(user: current_user))

    create_action(@expense, expenses_path, 'Despesa adicionada.')
  end

  # POST /expenses/create_from_csv
  def create_from_csv
    if params[:file].blank?
      redirect_to(new_from_csv_expenses_path, notice: 'Arquivo CSV é obrigatório.')
    else
      @results = enqueue_create_from_csv
      render(:new_from_csv)
    end
  end

  # PATCH/PUT /expenses/1
  def update
    if @expense.update(expense_params)
      redirect_to(expenses_path(expense_month: expense_month), notice: 'Despesa atualizada.')
    else
      render(:show)
    end
  end

  # DELETE /expenses/1
  def destroy
    @expense.destroy
    redirect_to(expenses_path(expense_month: expense_month), notice: 'Despesa removida.')
  end

  private

  def set_expense
    @expense = Expense.find_by(id: params[:id], user: current_user)
  end

  def expense_params
    params.require(:expense).permit(:description, :amount, :date, :fixed, :remark, :expense_category_id, :expense_group_id, :place_id)
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

  def expense_categories
    @expense_categories ||= fetch_expense_categories
  end

  def fetch_expense_categories
    ExpenseCategory.where(user: current_user).pluck(:name, :id)
  end

  def expense_month
    return Time.zone.today if params[:expense_month].blank?

    Date.parse(params[:expense_month])
  end

  def enqueue_create_from_csv
    CreateExpensesFromCsv.new(current_user, file_path).create_expenses
  end

  def file_path
    params[:file].tempfile.path
  end
end
