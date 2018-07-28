# frozen_string_literal: true

module API
  class GameProgressesController < ApplicationController

    actions :create, :show

    def show
      render json: {body: resource.verbose_report}
    end

  private

    def game_progress_params
      @game_progress_params ||= begin
        _gpp = parsed_params

        _gpp[:arrangement_progresses_attributes].reject! { |ap_attrs| ap_attrs[:play_count].to_i < 1 && ap_attrs[:sa_play_count].to_i < 1 }

        preloaded_ap_data = load_arrangement_progresses _gpp[:arrangement_progresses_attributes]

        _gpp[:arrangement_progresses_attributes].reject! do |ap_attrs|
          (preloaded_ap_data[ap_attrs[:identifier]] || []).any? do |existing|
            existing[0] == ap_attrs[:play_count] &&
            existing[1] == ap_attrs[:mastery]    &&
            existing[2] == ap_attrs[:date_sa]    &&
            existing[3] == ap_attrs[:date_las]   &&
            existing[4] == ap_attrs[:streak]
          end
        end

        _gpp
      end
    end

    def parsed_params
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

    def load_arrangement_progresses(arrangement_progresses_attributes)
      arrangement_identifiers = arrangement_progresses_attributes.map { |attrs| attrs[:identifier] }

      ArrangementProgress
        .joins(:arrangement)
        .where(user_id: current_user.id)
        .where(arrangements: {identifier: arrangement_identifiers})
        .where("steam_mins < ?", steam_mins)
        .select(:play_count)
        .select(:mastery)
        .select(:date_sa)
        .select(:date_las)
        .select(:streak)
        .select("arrangements.identifier AS arrangement_identifier")
        .inject({}) do |memo, ap|
          memo[ap.arrangement_identifier] ||= []
          memo[ap.arrangement_identifier] << [ap.play_count, ap.mastery.to_f, ap.date_sa, ap.date_las, ap.streak]
          memo
        end
    end

    def steam_mins
      params[:game_progress][:steam_mins]
    end
  end
end
