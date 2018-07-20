# frozen_string_literal: true

class SteamProfile

  attr_accessor :user

  delegate :steam_id, to: :user

  def initialize(user)
    @user = user
  end

  def minutes_played
    rocksmith_stats["playtime_forever"]
  end

  def achievement_count
    achievements
      .select { |a| a["achieved"] == 1 }
      .count
  end

  def achievements
    Steam::UserStats.player_achievements(RSGuitarTech::Steam::ROCKSMITH2014_APP_ID, steam_id)["achievements"]
  end

private

  def rocksmith_stats
    Steam::Player
      .owned_games(steam_id)["games"]
      .detect { |game| game["appid"] == RSGuitarTech::Steam::ROCKSMITH2014_APP_ID }
  end
end
