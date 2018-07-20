# frozen_string_literal: true

module API
  class GameProgressesController < ApplicationController

    actions :create, :show

    def show
      render json: {body: resource.verbose_report}
    end

  private

    def game_progress_params
      params.require(:game_progress).permit(
        :steam_mins, :ended_at,
        :session_seconds, :games_seconds, :lesson_second, :las_seconds, :rs_seconds, :missions_completed,
        :session_count, :songs_played_count, :session_mission_time, :longest_streak,
        arrangement_progresses_attributes: %i{
          identifier play_count mastery date_sa date_las streak
          sa_play_count sa_score_easy sa_score_medium sa_score_hard sa_score_master sa_pick_easy sa_pick_medium sa_pick_hard sa_pick_master
        }
      ).tap do |gpp|
        gpp[:user_id] = current_user.id
      end
    end
  end
end
