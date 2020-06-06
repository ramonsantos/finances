# frozen_string_literal: true

class ExpensesController < ApplicationController
  include I18nBasePath
  include CreateAction
  include UpdateAction
  include DestroyAction

  before_action :set_expense,        only: [:destroy, :show, :update]
  before_action :places,             only: [:new, :show]
  before_action :expense_groups,     only: [:new, :show]
  before_action :expense_categories, only: [:new, :show]

  # GET /expenses
  def index
    @expenses = Expense.fetch_by_month_order_by_date(current_user, expense_month).page(params[:page])
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

  # POST /expenses
  def create
    @expense = Expense.new(expense_params.merge!(user: current_user))

    create_action(@expense, expenses_path)
  end

  # PATCH/PUT /expenses/1
  def update
    update_action(@expense, expense_params, expenses_path(expense_month: expense_month))
  end

  # DELETE /expenses/1
  def destroy
    destroy_action(@expense, expenses_path(expense_month: expense_month))
  end

  private

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(
      :description,
      :amount,
      :date,
      :fixed,
      :remark,
      :expense_category_id,
      :expense_group_id,
      :place_id
    )
  end

  def places
    @places ||= current_user.places.pluck(:name, :id)
  end

  def expense_groups
    @expense_groups ||= current_user.expense_groups.order(:name).pluck(:name, :id)
  end

  def expense_categories
    @expense_categories ||= current_user.expense_categories.order(:name).pluck(:name, :id)
  end

  def expense_month
    @expense_month ||= choose_expense_month(params[:expense_month])
  end

  def choose_expense_month(expense_month)
    return Time.zone.today if expense_month.blank?

    Date.parse(expense_month)
  end
end
