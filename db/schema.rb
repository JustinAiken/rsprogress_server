# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171221235141) do

  create_table "arrangement_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "arrangement_id"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrangement_id"], name: "index_arrangement_data_on_arrangement_id"
  end

  create_table "arrangement_notes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "arrangement_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrangement_id"], name: "index_arrangement_notes_on_arrangement_id"
    t.index ["user_id"], name: "index_arrangement_notes_on_user_id"
  end

  create_table "arrangement_progresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "arrangement_id"
    t.bigint "game_progress_id"
    t.bigint "user_id"
    t.decimal "mastery", precision: 9, scale: 7
    t.integer "play_count", limit: 2
    t.integer "streak", limit: 2
    t.datetime "date_sa"
    t.datetime "date_las"
    t.integer "sa_play_count"
    t.integer "sa_pick_easy", limit: 1
    t.integer "sa_pick_medium", limit: 1
    t.integer "sa_pick_hard", limit: 1
    t.integer "sa_pick_master", limit: 1
    t.integer "sa_score_easy", default: 0, null: false
    t.integer "sa_score_medium", default: 0, null: false
    t.integer "sa_score_hard", default: 0, null: false
    t.integer "sa_score_master", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "steam_mins"
    t.index ["arrangement_id", "steam_mins"], name: "index_arrangement_progresses_on_arrangement_id_and_steam_mins"
    t.index ["arrangement_id"], name: "index_arrangement_progresses_on_arrangement_id"
    t.index ["date_las"], name: "index_arrangement_progresses_on_date_las"
    t.index ["date_sa"], name: "index_arrangement_progresses_on_date_sa"
    t.index ["game_progress_id"], name: "index_arrangement_progresses_on_game_progress_id"
    t.index ["mastery"], name: "index_arrangement_progresses_on_mastery"
    t.index ["play_count"], name: "index_arrangement_progresses_on_play_count"
    t.index ["sa_play_count"], name: "index_arrangement_progresses_on_sa_play_count"
    t.index ["steam_mins"], name: "index_arrangement_progresses_on_steam_mins"
    t.index ["user_id", "arrangement_id", "steam_mins"], name: "by_user_arr_id_and_steam_min"
  end

  create_table "arrangements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "song_id"
    t.string "identifier", null: false
    t.decimal "difficulty", precision: 9, scale: 7, default: "0.0", null: false
    t.integer "tuning_offset", limit: 2
    t.string "tuning"
    t.integer "capo", limit: 1
    t.integer "type", limit: 1
    t.index ["identifier"], name: "index_arrangements_on_identifier"
    t.index ["song_id"], name: "index_arrangements_on_song_id"
    t.index ["type"], name: "index_arrangements_on_type"
  end

  create_table "artists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "artist_name"
    t.string "artist_name_sort"
    t.index ["artist_name"], name: "index_artists_on_artist_name"
    t.index ["artist_name_sort"], name: "index_artists_on_artist_name_sort"
  end

  create_table "game_progresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.datetime "ended_at", null: false
    t.integer "steam_mins", null: false
    t.integer "session_seconds", default: 0, null: false
    t.integer "games_seconds", default: 0, null: false
    t.integer "lesson_second", default: 0, null: false
    t.integer "las_seconds", default: 0, null: false
    t.integer "rs_seconds", default: 0, null: false
    t.integer "missions_completed", default: 0, null: false
    t.integer "session_count", default: 0, null: false
    t.integer "songs_played_count", default: 0, null: false
    t.integer "session_mission_time", default: 0, null: false
    t.integer "longest_streak", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ended_at"], name: "index_game_progresses_on_ended_at"
    t.index ["steam_mins"], name: "index_game_progresses_on_steam_mins"
    t.index ["user_id"], name: "index_game_progresses_on_user_id"
  end

  create_table "personal_flags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "arrangement_id", null: false
    t.bigint "user_id", null: false
    t.date "happened_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrangement_id"], name: "index_personal_flags_on_arrangement_id"
    t.index ["user_id", "arrangement_id"], name: "index_personal_flags_on_user_id_and_arrangement_id"
    t.index ["user_id"], name: "index_personal_flags_on_user_id"
  end

  create_table "profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.string "steam_username"
    t.string "steam_id"
    t.boolean "public", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "songs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "artist_id"
    t.string "album_name", null: false
    t.string "album_name_sort", null: false
    t.string "dlc_type", null: false
    t.string "song_key", null: false
    t.decimal "song_length", precision: 8, scale: 4, default: "0.0", null: false
    t.string "song_name", null: false
    t.string "song_name_sort", null: false
    t.integer "song_year"
    t.string "dlc_key"
    t.index ["album_name"], name: "index_songs_on_album_name"
    t.index ["album_name_sort"], name: "index_songs_on_album_name_sort"
    t.index ["artist_id"], name: "index_songs_on_artist_id"
    t.index ["dlc_type"], name: "index_songs_on_dlc_type"
    t.index ["song_length"], name: "index_songs_on_song_length"
    t.index ["song_name"], name: "index_songs_on_song_name"
    t.index ["song_name_sort"], name: "index_songs_on_song_name_sort"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "username"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
