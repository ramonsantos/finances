# frozen_string_literal: true

module ApplicationHelper
  def current_year
    Time.zone.today.year
  end
end
