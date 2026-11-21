# frozen_string_literal: true

class ExpenseCreatorsController < ApplicationController
  def index
    @pagy, @expense_creators = pagy(:offset, ExpenseCreator.order(date: :desc))
  end

  def show
    @expense_creator = ExpenseCreator.find(params[:id])
  @pagy, @expense_creator_results = pagy(:offset, @expense_creator.expense_creator_results.order(:id))
  end

  def create
    unless params[:file].present?
      redirect_to expense_creators_path, alert: t(".file_required") and return
    end

    expense_creator = ExpenseCreator.create!(date: Time.zone.now, status: :queued)
    expense_creator.csv_file.attach(params[:file])
    ImportExpensesCsvJob.perform_later(expense_creator)

    redirect_to expense_creator_path(expense_creator), notice: t(".enqueued")
  end

  def download_csv_template
    send_file(
      Rails.root.join("public/csv_expense_template.csv"),
      type: "text/csv",
      disposition: "attachment",
      filename: t("expense_creators.template_filename")
    )
  end
end