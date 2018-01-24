FactoryBot.define do
  factory :game_progress do
    association :user

    steam_mins  { Faker::Number.number 5 }
    ended_at    { DateTime.current - rand(5).days }
  end
end
