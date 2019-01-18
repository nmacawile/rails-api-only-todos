FactoryBot.define do
  factory :item do
    name { Faker::Lorem.sentence }
    done { false }
    todo_id { nil }
  end
end
