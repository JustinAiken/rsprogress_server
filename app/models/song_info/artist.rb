# frozen_string_literal: true

module SongInfo
  class Artist < ActiveRecord::Base

    has_many :songs
    has_many :arrangements, through: :songs, inverse_of: :artist

    validates_presence_of :artist_name, :artist_name_sort
    validates_uniqueness_of :artist_name
  end
end
