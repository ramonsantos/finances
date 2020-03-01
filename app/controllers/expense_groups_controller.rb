# frozen_string_literal: true

class ExpenseGroupsController < ApplicationController
  # GET /expense_groups
  # GET /expense_groups.json
  def index
    @expense_groups = ExpenseGroup.where(user: current_user)
    @expense_group  = ExpenseGroup.new
  end

  # POST /expense_groups
  # POST /expense_groups.json
  def create
    @expense_group = ExpenseGroup.new(expense_group_params.merge!(user: current_user))

    respond_to do |format|
      if @expense_group.save
        format.html { redirect_to expense_groups_path, notice: 'Grupo de Despesas adicionado.' }
        format.json { render :index, status: :created, location: @expense_group }
      else
        format.html { render :index }
        format.json { render json: @expense_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expense_groups/1
  # DELETE /expense_groups/1.json
  def destroy
    respond_to do |format|
      if destroy_expense_group
        format.html { redirect_to expense_groups_path, notice: 'Grupo de Despesas removido.' }
        format.json { render :index, status: :created }
      else
        format.html { redirect_to expense_groups_path, notice: 'Ocorreu um erro ao remover o grupo de despesas.' }
        format.json { render json: { error: 'Ocorreu um erro ao remover o grupo de despesas.' }, status: :unprocessable_entity }
      end
    end
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
  rescue
    false
  end
end
