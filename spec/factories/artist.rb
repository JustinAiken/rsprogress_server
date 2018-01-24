FactoryBot.define do
  factory :artist, class: "SongInfo::Artist" do
    artist_name      { Faker::RockBand.unique.name }
    artist_name_sort { Faker::RockBand.unique.name }
  end
end
