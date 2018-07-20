# frozen_string_literal: true

class GameProgressesController < ApplicationController
  before_action :authenticate_user!

  def index
    @game_progresses =
      current_user.game_progresses
      .includes(arrangement_progresses: {arrangement: [:arrangement_progresses, {song: :artist}]})
      .order(steam_mins: :desc)
      .page(params[:page])
      .per(25)

  end
end
