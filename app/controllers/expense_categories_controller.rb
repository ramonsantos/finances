# frozen_string_literal: true

class ExpenseCategoriesController < ApplicationController
  include I18nBasePath
  include CreateAction
  include DestroyAction
  include UpdateAction

  before_action :expense_category, only: [:show, :update, :destroy]

  # GET /expense_categories
  def index
    @expense_categories = current_user.expense_categories.order(:name)
  end

  # GET /expense_categories/1
  def show
  end

  # GET /expense_categories/new
  def new
    @expense_category = ExpenseCategory.new
  end

  # POST /expense_categories
  def create
    @expense_category = ExpenseCategory.new(expense_category_params.merge!(user: current_user))

    create_action(@expense_category, expense_categories_path)
  end

  # PATCH/PUT /expense_categories/1
  def update
    update_action(@expense_category, expense_category_params, expense_categories_path)
  end

  # DELETE /expense_categories/1
  def destroy
    destroy_action(@expense_category, expense_categories_path)
  end

  private

  def expense_category
    @expense_category ||= current_user.expense_categories.find(params[:id])
  end

  def expense_category_params
    params.require(:expense_category).permit(:name, :description)
  end
end
