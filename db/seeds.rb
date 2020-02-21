if Rails.env.development?
  FactoryBot.create(:user)
  FactoryBot.create(:place)
  FactoryBot.create(:place, name: 'Surubim')
  FactoryBot.create(:expense_group)
  FactoryBot.create(:expense_group, name: 'Home')
end
