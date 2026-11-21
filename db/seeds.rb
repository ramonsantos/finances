# frozen_string_literal: true

categories = ['Alimentação', 'Educação', 'Lazer', 'Saúde', 'Transporte']
categories.each do |name|
  ExpenseCategory.find_or_create_by!(name: name)
end

ExpenseGroup.find_or_create_by!(name: 'Pessoal')
