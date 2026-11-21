# frozen_string_literal: true

class ExpensesController < ApplicationController
  include ResourceResponses

  before_action :set_expense, only: [:show, :update, :destroy]
  before_action :load_form_options, only: [:new, :show, :create, :update]

  def index
    @current_expense_month = expense_month_from_params
    @pagy, @expenses = pagy(:offset, Expense.for_month_ordered(@current_expense_month))
    @total_expense_amount = Expense.total_for_month(@current_expense_month)
  end

  def report
    @current_expense_month = expense_month_from_params
    @expenses_grouped_data = Expense.report_data(@current_expense_month)
  end

  def show
    @current_expense_month = expense_month_from_params
  end

  def new
    @expense = Expense.new(date: Time.zone.today)
    @current_expense_month = expense_month_from_params
  end

  def create
    @expense = Expense.new(expense_params)
    @current_expense_month = expense_month_from_params
    create_resource(@expense, expenses_path(expense_month: @current_expense_month))
  end

  def update
    @current_expense_month = expense_month_from_params
    update_resource(
      @expense,
      expense_params,
      expense_path(@expense, expense_month: @current_expense_month)
    )
  end

  def destroy
    month = helpers.parse_expense_month(params[:expense_month])
    destroy_resource(@expense, expenses_path(expense_month: month))
  end

  private

  def set_expense
    @expense = Expense.find(params.expect(:id))
  end

  def expense_params
    params.expect(
      expense: [
        :description,
        :amount,
        :date,
        :fixed,
        :remark,
        :expense_category_id,
        :expense_group_id
      ]
    )
  end

  def load_form_options
    @expense_categories = ExpenseCategory.order(:name).pluck(:name, :id)
    @expense_groups = ExpenseGroup.order(:name).pluck(:name, :id)
  end

  def expense_month_from_params
    helpers.parse_expense_month(params[:expense_month])
  end
end
