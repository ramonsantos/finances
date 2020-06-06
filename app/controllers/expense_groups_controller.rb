# frozen_string_literal: true

class ExpenseGroupsController < ApplicationController
  include I18nBasePath
  include CreateAction
  include DestroyAction

  before_action :expense_group, only: [:destroy]

  # GET /expense_groups
  def index
    @expense_groups = current_user.expense_groups.order(:name)
    @expense_group  = ExpenseGroup.new
  end

  # POST /expense_groups
  def create
    @expense_group = ExpenseGroup.new(expense_group_params)

    create_action(@expense_group, expense_groups_path, :index)
  end

  # DELETE /expense_groups/1
  def destroy
    destroy_action(@expense_group, expense_groups_path)
  end

  private

  def expense_group_params
    params.require(:expense_group).permit(:name).merge!(user: current_user)
  end

  def expense_group
    @expense_group ||= current_user.expense_groups.find(params[:id])
  end
end
