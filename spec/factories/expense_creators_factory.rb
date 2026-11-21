# frozen_string_literal: true

FactoryBot.define do
  factory :expense_creator do
    date { Time.zone.now }
    status { :queued }

    trait :with_csv do
      after(:build) do |creator|
        creator.csv_file.attach(
          io: StringIO.new("Descrição,Valor,Data,Categoria,Grupo de Despesa,Fixo?,Observações\n"),
          filename: 'test.csv',
          content_type: 'text/csv'
        )
      end
    end
  end
end
