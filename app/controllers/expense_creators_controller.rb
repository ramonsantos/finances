# frozen_string_literal: true

class ExpenseCreatorsController < ApplicationController
  # GET /expense_creators
  def index
    @expense_creators = current_user.expense_creators
  end

  # GET /expense_creator/1
  def show
    @expense_creator = ExpenseCreator.find_by(user: current_user, id: params[:id])
    @expense_creator_results = @expense_creator.expense_creator_results.page(params[:page])
  end

  # POST /expense_creators
  def create
    if params[:file].blank?
      redirect_to(expense_creators_path, notice: 'Arquivo CSV é obrigatório.')
    else
      expense_creator = ExpenseCreator.create!(date: Time.zone.now, user: current_user)
      expense_creator.create_from_csv!(file_path)

      redirect_to(expense_creator_path(expense_creator))
    end
  end

  private

  def file_path
    params[:file].tempfile.path
  end
end
