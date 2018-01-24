FactoryBot.define do
  factory :arrangement, class: "SongInfo::Arrangement" do
    association :song

    identifier       { Faker::Internet.password 32, 32 }
    type             { SongInfo::Arrangement.types.keys.sample }
    tuning           { "E Standard" }
    difficulty       { Faker::Number.decimal 0, 6 }
  end
end
