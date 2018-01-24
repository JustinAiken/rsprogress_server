FactoryBot.define do
  factory :song, class: "SongInfo::Song" do
    association :artist

    album_name      { Faker::Company.unique.bs }
    album_name_sort { Faker::Company.unique.bs }
    dlc_type        { SongInfo::Song::DLC_TYPES.sample }
    song_key        { Faker::Company.unique.bs }
    song_length     { rand(200) }
    song_name       { Faker::Company.unique.bs }
    song_name_sort  { Faker::Company.unique.bs }
    song_year       { (1930..2018).to_a.sample }
  end
end
