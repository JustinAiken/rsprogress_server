module SongInfo
  class Song < ActiveRecord::Base

    belongs_to :artist
    has_many :arrangements

    DLC_TYPES = %w{disc rs1 rs1_dlc dlc cdlc}

    before_validation :set_sort_name
    before_save       :set_dlc_key

    validates_presence_of :artist, :album_name, :dlc_type, :song_key, :song_length, :song_name, :song_name_sort, :song_year
    validates_uniqueness_of :song_name, scope: :artist_id
    validates_uniqueness_of :song_key
    validates_inclusion_of :dlc_type, in: DLC_TYPES

    def cdlc?
      dlc_type == "cdlc"
    end

  private

    def set_sort_name
      self.album_name_sort = self.album_name if self.album_name_sort.blank?
    end

    def set_dlc_key
      self.dlc_key ||= arrangements.first&.data&.fetch("DLCKey", nil)
    end
  end
end
