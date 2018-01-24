FactoryBot.define do
  factory :user do
    sequence(:email)      { |n| "user#{n}@foo.com" }
    password              { "Secret123" }
    password_confirmation { "Secret123" }
    admin                 false

    factory :admin_user do
      admin true
    end
  end
end
