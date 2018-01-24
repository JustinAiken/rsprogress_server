FactoryBot.define do
  factory :arrangement_progress do
    association :game_progress
    association :arrangement

    mastery        { 0.955007 }
    play_count     { 5 }
    streak          396
    date_sa         nil
    date_las        { DateTime.current - 1.day }
    sa_play_count   0
    sa_pick_easy    nil
    sa_pick_medium  nil
    sa_pick_hard    nil
    sa_pick_master  nil
    sa_score_easy   0
    sa_score_medium 0
    sa_score_hard   0
    sa_score_master 0
  end
end
