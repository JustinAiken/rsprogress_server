require_relative "config/application"
Rails.application.load_tasks

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
