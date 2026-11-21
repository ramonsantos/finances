# frozen_string_literal: true

class ExpenseGroupsController < ApplicationController
  include ResourceResponses

  before_action :set_expense_group, only: :destroy
  before_action :load_expense_groups, only: [:index, :create]

  def index
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
    @expense_group = ExpenseGroup.find(params.expect(:id))
  end

  def expense_group_params
    params.expect(expense_group: [:name])
  end

  def load_expense_groups
    @expense_groups = ExpenseGroup.order(:name)
  end
end
