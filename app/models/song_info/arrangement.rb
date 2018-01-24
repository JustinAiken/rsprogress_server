module SongInfo
  class Arrangement < ActiveRecord::Base

    # disable STI
    self.inheritance_column = :_type_disabled

    enum type: %i{
      lead rhythm bass
      bonus_lead bonus_rhythm bonus_bass
      alternate_lead alternate_rhythm
      5_string_bass
    }

    belongs_to :song
    has_one :artist, through: :song, inverse_of: :arrangements
    has_many :arrangement_progresses
    has_many :arrangement_notes
    has_many :personal_flags
    has_one :arrangement_data, inverse_of: :arrangement

    delegate :data, :data=,       to: :arrangement_data_relation
    delegate :cdlc?,              to: :song
    delegate :artist, :song_name, to: :song
    delegate :artist_name,        to: :artist

    attr_accessor :raw_json, :dlc_type

    def arrangement_data_relation
      arrangement_data || build_arrangement_data
    end

    validates_presence_of :identifier, :type, :difficulty
    validates_uniqueness_of :identifier

    before_validation :set_identifier,  if: :rippable?
    before_validation :parse_json,      if: :rippable?
    before_validation :fill_in_details, if: :new_record?
    before_save       :bump_difficulty, if: :cdlc?

    scope :cdlc,   -> { joins(:song).where songs: {dlc_type: :cdlc} }
    scope :guitar, -> { where.not type: %i{bass 5_string_bass} }

    TUNING_MAPPINGS = {
      any_standard: "Any Standard",
      any_drop:     "Any Drop-D",
      e_standard:   "E Standard",
      eb_standard:  "Eb Standard",
      d_standard:   "D Standard",
      cs_standard:  "C# Standard",
      drop_d:       "Drop D",
      eb_drop_db:   "Eb Drop Db"
    }.to_a

    def to_s
      "#{artist_name} - #{song_name} (#{type})"
    end

  private

    def set_identifier
      self.identifier ||= raw_json['Entries'].keys.first
    end

    def parse_json
      SongInfo::Arrangements::ManifestFile.new(self).rip!
    end

    def fill_in_details
      ArrangementDetailer.new(self).detail if data.present?
    end

    def rippable?
      raw_json.present?
    end

    def bump_difficulty
      self.difficulty = self.difficulty + 1 if self.difficulty < 1
    end
  end
end
