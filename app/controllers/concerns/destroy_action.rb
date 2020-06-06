# frozen_string_literal: true

module DestroyAction
  extend ActiveSupport::Concern

  private

  def try_destroy(model)
    model.destroy

    { notice: destroy_messages(:success) }
  rescue StandardError
    { alert: destroy_messages(:error) }
  end

  def destroy_messages(result)
    t("#{i18n_base_path}.destroy_#{result}")
  end
end
