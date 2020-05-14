# frozen_string_literal: true

class ExpenseGroupsController < ApplicationController
  include CreateAction

  # GET /expense_groups
  def index
    @expense_groups = ExpenseGroup.where(user: current_user)
    @expense_group  = ExpenseGroup.new
  end

  # POST /expense_groups
  def create
    @expense_group = ExpenseGroup.new(expense_group_params.merge!(user: current_user))

    create_action(@expense_group, expense_groups_path, 'Grupo de Despesas adicionado.', :index)
  end

  # DELETE /expense_groups/1
  def destroy
    redirect_to(expense_groups_path, try_destroy)
  end

  private

  def expense_group_params
    params.require(:expense_group).permit(:name)
  end

  def fetch_expense_group
    ExpenseGroup.find(params[:id])
  end

  def try_destroy
    fetch_expense_group.destroy
    { notice: 'Grupo de Despesas removido.' }
  rescue StandardError
    { alert: 'Ocorreu um erro ao remover o grupo de despesas.' }
  end
end
