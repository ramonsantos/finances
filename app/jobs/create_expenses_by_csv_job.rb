# frozen_string_literal: true

class CreateExpensesByCsvJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
