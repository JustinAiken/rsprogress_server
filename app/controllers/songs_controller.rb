# frozen_string_literal: true

class SongsController < ApplicationController

  load_resource :artist, parent: true, class: "SongInfo::Artist"
  load_resource class: "SongInfo::Song", through: :artist, if: -> { @artist.present? }
  load_resource class: "SongInfo::Song"

  def index
    @songs = @songs.includes(:artist)
    @songs = @songs.order("artists.artist_name_sort ASC, songs.song_name_sort ASC").limit(100)
  end

  def show
    @song = SongInfo::Song
      .where(dlc_key: params[:id])
      .or(SongInfo::Song.where(song_key: params[:id]))
      .includes(:arrangements)
      .first
  end
end
