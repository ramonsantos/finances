# frozen_string_literal: true

module CreateAction
  extend ActiveSupport::Concern

  private

  def create_action(model, success_path, error_render = :new)
    if model.save
      redirect_to(success_path, notice: t("#{i18n_base_path}.created"))
    else
      render(error_render)
    end
  end
end
