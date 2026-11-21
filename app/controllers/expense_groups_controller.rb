# frozen_string_literal: true

class ExpenseGroupsController < ApplicationController
  include ResourceResponses

  before_action :set_expense_group, only: :destroy

  def index
    @expense_groups = ExpenseGroup.order(:name)
    @expense_group = ExpenseGroup.new
  end

  def create
    @expense_group = ExpenseGroup.new(expense_group_params)
    create_resource(@expense_group, expense_groups_path, :index)
  end

  def destroy
    destroy_resource(@expense_group, expense_groups_path)
  end

  private

  def set_expense_group
    @expense_group = ExpenseGroup.find(params[:id])
  end

  def expense_group_params
    params.require(:expense_group).permit(:name)
  end
end