# frozen_string_literal: true

module UpdateAction
  extend ActiveSupport::Concern

  private

  def update_action(model, model_params, success_path)
    if model.update(model_params)
      redirect_to(success_path, notice: t("#{i18n_base_path}.updated"))
    else
      render(:show)
    end
  end
end
