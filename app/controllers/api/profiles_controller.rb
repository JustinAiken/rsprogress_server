# frozen_string_literal: true

module API
  class ProfilesController < ApplicationController

    def show
      steam = SteamProfile.new(current_user)
      render json: {
        email:      current_user.email,
        steam_id:   steam.steam_id,
        steam_mins: steam.minutes_played
      }
    end
  end
end
