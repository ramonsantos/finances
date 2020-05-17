# frozen_string_literal: true

module DestroyAction
  extend ActiveSupport::Concern

  private

  def try_destroy(model, messages)
    model.destroy

    { notice: messages[:success] }
  rescue StandardError
    { alert: messages[:error] }
  end
end
