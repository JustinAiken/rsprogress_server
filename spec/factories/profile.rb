FactoryBot.define do
  factory :profile do
    association :user

    public          { false }
    steam_username  { Faker::Company.unique.bs }
    steam_id        { Faker::Number.number 32 }
  end
end
