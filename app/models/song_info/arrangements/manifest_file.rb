# frozen_string_literal: true

module SongInfo
  module Arrangements
    class ManifestFile

      attr_accessor :arrangement
      delegate :raw_json, :identifier, :dlc_type, to: :arrangement

      def initialize(arrangement)
        @arrangement = arrangement
      end

      ARTIST_MAPPINGS = {
        "Grace Potter and The Nocturnals" => "Grace Potter and The Nocturnals",
        "Grace Potter & The Nocturnals"   => "Grace Potter and The Nocturnals"
      }

      def rip!
        arrangement.song   = song
        arrangement.artist = artist
        arrangement.data   = attributes
        puts arrangement.to_s
      rescue => e
        puts e
      end

      def artist
        @artist ||= begin
          artist_name = ARTIST_MAPPINGS[attributes['ArtistName']] || attributes['ArtistName']
          _artist     = SongInfo::Artist.find_or_initialize_by(artist_name: artist_name)
          _artist.artist_name_sort = attributes['ArtistNameSort']
          _artist
        end
      end

      def song
        @song ||= SongInfo::Song.find_or_initialize_by(artist_id: artist.id, song_key: attributes['SongKey']).tap do |_song|
          _song.album_name      = attributes['AlbumName']
          _song.album_name_sort = attributes['AlbumNameSort']
          _song.song_name       = attributes['SongName']
          _song.song_name_sort  = attributes['SongNameSort']
          _song.song_year       = attributes['SongYear']
          _song.dlc_type        = dlc_type
          _song.song_length     = attributes['SongLength'].to_s
        end
      end

    private

      def attributes
        raw_json['Entries'][identifier]['Attributes']
      end
    end
  end
end
