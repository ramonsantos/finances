# frozen_string_literal: true

class ExpenseGroupsController < ApplicationController
  # GET /expense_groups
  def index
    @expense_groups = ExpenseGroup.where(user: current_user)
    @expense_group  = ExpenseGroup.new
  end

  # POST /expense_groups
  def create
    @expense_group = ExpenseGroup.new(expense_group_params.merge!(user: current_user))

    if @expense_group.save
      redirect_to(expense_groups_path, notice: 'Grupo de Despesas adicionado.')
    else
      render(:index)
    end
  end

  # DELETE /expense_groups/1
  def destroy
    redirect_to(expense_groups_path, notice: destroy_notice(destroy_expense_group))
  end

  private

  def expense_group_params
    params.require(:expense_group).permit(:name)
  end

  def fetch_expense_group
    ExpenseGroup.find(params[:id])
  end

  def destroy_expense_group
    fetch_expense_group.destroy
    true
  rescue StandardError
    false
  end

  def destroy_notice(result)
    result ? 'Grupo de Despesas removido.' : 'Ocorreu um erro ao remover o grupo de despesas.'
  end
end
