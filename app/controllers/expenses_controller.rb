# frozen_string_literal: true

class ExpensesController < ApplicationController
  include ResourceResponses

  before_action :set_expense, only: [:update, :destroy]
  before_action :load_form_options, only: [:index, :report, :create, :update]

  def index
    prepare_index_context
    @new_expense = Expense.new(date: default_expense_date)
    @open_expense_modal = false
    @open_edit_expense_id = nil
  end

  def report
    @current_expense_month = expense_month_from_params
    @category_report = Expense.category_report_data(@current_expense_month)
    @payment_method_report = Expense.payment_method_report_data(@current_expense_month)
    @total_expense_amount = Expense.total_for_month(@current_expense_month)
    @new_expense = Expense.new(date: default_expense_date)
    @open_expense_modal = false
  end

  def create
    @current_expense_month = expense_month_from_params
    @new_expense = Expense.new(expense_params)

    if @new_expense.save
      redirect_to(
        expenses_path(expense_month: helpers.expense_month_param(@new_expense.date)),
        notice: t('.created')
      )
    else
      prepare_index_context
      @open_expense_modal = true
      @open_edit_expense_id = nil
      render(:index, status: :unprocessable_content)
    end
  end

  def update
    @current_expense_month = expense_month_from_params

    if @expense.update(expense_params)
      redirect_to(
        expenses_path(expense_month: helpers.expense_month_param(@expense.date)),
        notice: t('.updated')
      )
    else
      prepare_index_context
      @new_expense = Expense.new(date: default_expense_date)
      @open_expense_modal = false
      @open_edit_expense_id = @expense.id
      render(:index, status: :unprocessable_content)
    end
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
        :essential,
        :remark,
        :expense_category_id,
        :payment_method_id
      ]
    )
  end

  def load_form_options
    @expense_categories = ExpenseCategory.order(:name).pluck(:name, :id)
    @payment_methods = PaymentMethod.order(:name).pluck(:name, :id)
  end

  def expense_month_from_params
    helpers.parse_expense_month(params[:expense_month])
  end

  def prepare_index_context
    @current_expense_month = expense_month_from_params
    @pagy, @expenses = pagy(:offset, Expense.for_month_ordered(@current_expense_month))
    @total_expense_amount = Expense.total_for_month(@current_expense_month)
  end

  def default_expense_date
    today = Time.zone.today
    month = @current_expense_month

    return today if today.year == month.year && today.month == month.month

    month.beginning_of_month
  end
end
