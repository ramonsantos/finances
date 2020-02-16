if Rails.env.development?
  FactoryBot.create(:user)
  FactoryBot.create(:place)
  FactoryBot.create(:expense_group)
end
