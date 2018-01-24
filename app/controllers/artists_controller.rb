class ArtistsController < ApplicationController

  def index
    @artists = SongInfo::Artist
      .includes(songs: :arrangements)
      .order("artists.artist_name_sort ASC")
      .limit(100)
  end
end
