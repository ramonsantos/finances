# frozen_string_literal: true

class ExpenseGroupsController < ApplicationController
  include CreateAction
  include DestroyAction

  before_action :expense_group, only: [:destroy]

  # GET /expense_groups
  def index
    @expense_groups = ExpenseGroup.where(user: current_user).order(:name)
    @expense_group  = ExpenseGroup.new
  end

  # POST /expense_groups
  def create
    @expense_group = ExpenseGroup.new(expense_group_params.merge!(user: current_user))

    create_action(@expense_group, expense_groups_path, 'Grupo de Despesas adicionado.', :index)
  end

  # DELETE /expense_groups/1
  def destroy
    redirect_to(expense_groups_path, try_destroy(@expense_group, destroy_messages))
  end

  private

  def expense_group_params
    params.require(:expense_group).permit(:name)
  end

  def expense_group
    @expense_group ||= fetch_expense_group
  end

  def fetch_expense_group
    ExpenseGroup.find_by(id: params[:id], user: current_user)
  end

  def destroy_messages
    {
      success: 'Grupo de Despesas removido.',
      error: 'Ocorreu um erro ao remover o grupo de despesas.'
    }
  end
end
