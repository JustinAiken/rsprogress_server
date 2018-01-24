FactoryBot.define do
  factory :arrangement_datum, class: "SongInfo::ArrangementDatum" do
    association :arrangement
    data nil
  end
end
