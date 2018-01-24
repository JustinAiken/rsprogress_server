FactoryBot.define do
  factory :arrangement_note do
    association :user
    association :arrangement

    body "MyText"
  end
end
