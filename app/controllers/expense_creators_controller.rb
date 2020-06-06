# frozen_string_literal: true

class ExpenseCreatorsController < ApplicationController
  include I18nBasePath

  # GET /expense_creators
  def index
    @expense_creators = current_user.expense_creators.order(date: :desc).page(params[:page])
  end

  # GET /expense_creator/1
  def show
    @expense_creator = current_user.expense_creators.find(params[:id])
    @expense_creator_results = @expense_creator.expense_creator_results.page(params[:page])
  end

  # POST /expense_creators
  def create
    if params[:file].present?
      do_create
    else
      redirect_to(expense_creators_path, alert: t("#{i18n_base_path}.alert.required_file"))
    end
  end

  # GET /expense_creators/download_csv_template
  def download_csv_template
    send_file(csv_template_file_name, type: 'text/csv', status: 202)
  end

  private

  def do_create
    expense_creator = ExpenseCreator.create!(date: Time.zone.now, user: current_user)
    expense_creator.create_from_csv(file_path)

    redirect_to(expense_creator_path(expense_creator), notice: t("#{i18n_base_path}.notice.creation_process_finished"))
  end

  def file_path
    params[:file].tempfile.path
  end

  def csv_template_file_name
    "#{Rails.root}/public/#{t("#{i18n_base_path}.csv_file_name")}"
  end
end
