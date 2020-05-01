# frozen_string_literal: true

class ExpenseCategoriesController < ApplicationController
  before_action :set_expense_category, only: [:show, :update, :destroy]

  # GET /expense_categories
  # GET /expense_categories.json
  def index
    @expense_categories = ExpenseCategory.where(user: current_user)
  end

  # GET /expense_categories/1
  # GET /expense_categories/1.json
  def show
  end

  # GET /expense_categories/new
  def new
    @expense_category = ExpenseCategory.new
  end

  # POST /expense_categories
  # POST /expense_categories.json
  def create
    @expense_category = ExpenseCategory.new(expense_category_params.merge!(user: current_user))

    respond_to do |format|
      if @expense_category.save
        format.html { redirect_to expense_categories_path, notice: 'Categoria de Despesa adicionada.' }
        format.json { render :show, status: :created, location: @expense_category }
      else
        format.html { render :new }
        format.json { render json: @expense_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expense_categories/1
  # PATCH/PUT /expense_categories/1.json
  def update
    respond_to do |format|
      if @expense_category.update(expense_category_params)
        format.html { redirect_to expense_categories_path, notice: 'Categoria de Despesa atualizada.' }
        format.json { render :show, status: :ok, location: @expense_category }
      else
        format.html { render :show }
        format.json { render json: @expense_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expense_categories/1
  # DELETE /expense_categories/1.json
  def destroy
    @expense_category.destroy
    respond_to do |format|
      format.html { redirect_to expense_categories_url, notice: 'Categoria de Despesa removida.' }
      format.json { head :no_content }
    end
  end

  private

  def set_expense_category
    @expense_category = ExpenseCategory.find_by(id: params[:id], user: current_user)
  end

  def expense_category_params
    params.require(:expense_category).permit(:name, :description)
  end
end
