# frozen_string_literal: true

class ExpenseCategoriesController < ApplicationController
  include ResourceResponses

  before_action :set_expense_category, only: [:update, :destroy]

  def index
    prepare_index_context
    @new_expense_category = ExpenseCategory.new
    @open_expense_category_modal = false
    @open_edit_expense_category_id = nil
  end

  def create
    @new_expense_category = ExpenseCategory.new(expense_category_params)

    if @new_expense_category.save
      redirect_to(expense_categories_path, notice: t('.created'))
    else
      prepare_index_context
      @open_expense_category_modal = true
      @open_edit_expense_category_id = nil
      render(:index, status: :unprocessable_content)
    end
  end

  def update
    if @expense_category.update(expense_category_params)
      redirect_to(expense_categories_path, notice: t('.updated'))
    else
      prepare_index_context
      @new_expense_category = ExpenseCategory.new
      @open_expense_category_modal = false
      @open_edit_expense_category_id = @expense_category.id
      render(:index, status: :unprocessable_content)
    end
  end

  def destroy
    destroy_resource(@expense_category, expense_categories_path)
  end

  private

  def set_expense_category
    @expense_category = ExpenseCategory.find(params.expect(:id))
  end

  def expense_category_params
    params.expect(expense_category: [:name, :description])
  end

  def prepare_index_context
    @expense_categories = ExpenseCategory.order(:name)
  end
end
