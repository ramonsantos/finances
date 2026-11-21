# frozen_string_literal: true

class ExpenseCategoriesController < ApplicationController
  include ResourceResponses

  before_action :set_expense_category, only: [:show, :update, :destroy]

  def index
    @expense_categories = ExpenseCategory.order(:name)
  end

  def show; end

  def new
    @expense_category = ExpenseCategory.new
  end

  def create
    @expense_category = ExpenseCategory.new(expense_category_params)
    create_resource(@expense_category, expense_categories_path)
  end

  def update
    update_resource(@expense_category, expense_category_params, expense_categories_path)
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
end
