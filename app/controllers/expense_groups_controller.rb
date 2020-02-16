# frozen_string_literal: true

class ExpenseGroupsController < ApplicationController
  # GET /expense_groups
  # GET /expense_groups.json
  def index
    @expense_groups = ExpenseGroup..where(user: current_user)
  end

  # GET /expense_groups/new
  def new
    @expense_group = ExpenseGroup.new
  end

  # POST /expense_groups
  # POST /expense_groups.json
  def create
    @expense_group = ExpenseGroup.new(expense_group_params)
    @expense_group.user = current_user

    respond_to do |format|
      if @expense_group.save
        format.html { redirect_to @expense_group, notice: 'Expense group was successfully created.' }
        format.json { render :show, status: :created, location: @expense_group }
      else
        format.html { render :new }
        format.json { render json: @expense_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expense_groups/1
  # DELETE /expense_groups/1.json
  def destroy
    ExpenseGroup.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to expense_groups_url, notice: 'Expense group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def expense_group_params
    params.require(:expense_group).permit(:name)
  end
end
