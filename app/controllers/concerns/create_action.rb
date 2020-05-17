# frozen_string_literal: true

module CreateAction
  extend ActiveSupport::Concern

  private

  def create_action(model, success_path, notice, error_render = :new)
    if model.save
      redirect_to(success_path, notice: notice)
    else
      render(error_render)
    end
  end
end
