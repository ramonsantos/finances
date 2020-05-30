# frozen_string_literal: true

FactoryBot.define do
  factory :expense_creator_result do
    expense_creator { ExpenseCreator.first || create(:expense_creator) }

    raw_content { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Casa,Surubim,Sim,' }
    success { true }
    details { 'Sucesso' }

    trait :expense_creator_result_error do
      raw_content { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Casa,Garanhuns,Sim,' }
      success { false }
      details { 'Erro: Local não encontrado' }
    end

    factory :expense_creator_result_error, traits: [:expense_creator_result_error]
  end
end
