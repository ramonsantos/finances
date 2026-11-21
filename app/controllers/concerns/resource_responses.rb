# frozen_string_literal: true

module ResourceResponses
  extend ActiveSupport::Concern

  private

  def create_resource(record, success_path, error_view = :new)
    if record.save
      redirect_to(success_path, notice: t('.created'))
    else
      render(error_view, status: :unprocessable_content)
    end
  end

  def update_resource(record, attributes, success_path, error_view = :show)
    if record.update(attributes)
      redirect_to(success_path, notice: t('.updated'))
    else
      render(error_view, status: :unprocessable_content)
    end
  end

  def destroy_resource(record, redirect_path)
    if record.destroy
      redirect_to(redirect_path, notice: t('.destroyed'))
    else
      redirect_to(redirect_path, alert: t('.destroy_failed'))
    end
  end
end
