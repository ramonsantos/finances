# frozen_string_literal: true

if Rails.env.development?
  FactoryBot.create(:user)
  FactoryBot.create(:place)
  FactoryBot.create(:place_surubim)
  FactoryBot.create(:expense_group)
  FactoryBot.create(:expense_group_home)
end
