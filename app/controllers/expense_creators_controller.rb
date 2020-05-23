# frozen_string_literal: true

class ExpenseCreatorsController < ApplicationController
  # GET /expense_creators
  def index
    @results = {}
  end

  # POST /expense_creators
  def create
    if params[:file].blank?
      redirect_to(expense_creators_path, notice: 'Arquivo CSV é obrigatório.')
    else
      @results = CreateExpensesFromCsv.new(current_user, file_path).create_expenses
      render(:index)
    end
  end

  private

  def file_path
    params[:file].tempfile.path
  end
end
