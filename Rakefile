require_relative "config/application"
Rails.application.load_tasks


desc "Add to csv"
task add_to_csv: :environment do
  fail "Usage: add_to_csv 9 2018-12-09 'Name of Pack'" unless ARGV[1]
  ARGV.each { |a| task a.to_sym do ; end }

  number   = ARGV[1].to_i
  dlc_date = ARGV[2] ? Date.parse(ARGV[2]) : Date.current
  dlc_name = ARGV[3]

  SongInfo::Arrangement
    .official
    .joins(:artist)
    .select(:song_id)
    .select(:identifier)
    .select("songs.song_name AS song_title")
    .select("artists.artist_name AS artist_name")
    .last(number)
    .each do |arrangement|
      data = [dlc_date, dlc_name, arrangement.artist_name, arrangement.song_title, arrangement.identifier, "0.50"]
      puts data.join(",")
    end
end

namespace :db do
  desc "Nuke everything but users"
  task nuke: :environment do
    SongInfo::Artist.delete_all
    SongInfo::Song.delete_all
    SongInfo::Arrangement.delete_all
    ArrangementProgress.delete_all
    GameProgress.delete_all
    PersonalFlag.delete_all
    ArrangementNote.delete_all
  end

  desc "Nuke just progress"
  task nuke_progress: :environment do
    ArrangementProgress.delete_all
    GameProgress.delete_all
    ArrangementNote.delete_all
  end

  namespace :seed do
    desc "Dump songinfo"
    task dump: :environment do
      Sprig.reap target_env: :shared, models: [
        SongInfo::Artist,
        SongInfo::Song,
        SongInfo::Arrangement
      ]
    end
  end
end

namespace :arrangements do
  desc "Detail Arrangements"
  task detail: :environment do
    SongInfo::Arrangement.includes(:song, :arrangement_data).all.find_each do |arr|
      next unless arr.arrangement_data.present?
      ArrangementDetailer.detail! arr
    end
  end
end
