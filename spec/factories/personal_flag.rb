FactoryBot.define do
  factory :personal_flag do
    association :user
    association :arrangement

    happened_at { 1.week.ago }
  end
end
