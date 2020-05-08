# frozen_string_literal: true

class ExpenseCategoriesController < ApplicationController
  before_action :set_expense_category, only: [:show, :update, :destroy]

  # GET /expense_categories
  def index
    @expense_categories = ExpenseCategory.where(user: current_user)
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

    if @expense_category.save
      redirect_to(expense_categories_path, notice: 'Categoria de Despesa adicionada.')
    else
      render(:new)
    end
  end

  # PATCH/PUT /expense_categories/1
  def update
    if @expense_category.update(expense_category_params)
      redirect_to(expense_categories_path, notice: 'Categoria de Despesa atualizada.')
    else
      render(:show)
    end
  end

  # DELETE /expense_categories/1
  def destroy
    @expense_category.destroy
    redirect_to(expense_categories_url, notice: 'Categoria de Despesa removida.')
  end

  private

  def set_expense_category
    @expense_category = ExpenseCategory.find_by(id: params[:id], user: current_user)
  end

  def expense_category_params
    params.require(:expense_category).permit(:name, :description)
  end
end
