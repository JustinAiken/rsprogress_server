# frozen_string_literal: true

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

    scope :cdlc,     -> { joins(:song).where songs: {dlc_type: :cdlc} }
    scope :official, -> { joins(:song).where.not songs: {dlc_type: :cdlc} }
    scope :guitar,   -> { where.not type: %i{bass 5_string_bass} }
    scope :bass,     -> { where     type: %i{bass 5_string_bass} }

    UNPLAYED_SQL = <<~SQL
      LEFT OUTER JOIN arrangement_progresses ON
      arrangement_progresses.arrangement_id = arrangements.id
      AND arrangement_progresses.user_id =
    SQL

    scope :unplayed_by, ->(user) {
      distinct
        .joins(UNPLAYED_SQL, user.id.to_s)
        .where(arrangement_progresses: {id: nil})
    }

    scope :any_standard, -> { where tuning: [
      TUNING_MAPPINGS[:e_standard],
      TUNING_MAPPINGS[:eb_standard],
      TUNING_MAPPINGS[:d_standard],
      TUNING_MAPPINGS[:cs_standard],
      TUNING_MAPPINGS[:c_standard],
      TUNING_MAPPINGS[:b_standard]
    ]}

    TUNING_MAPPINGS = {
      e_standard:   "E Standard",
      eb_standard:  "Eb Standard",
      d_standard:   "D Standard",
      cs_standard:  "C# Standard",
      c_standard:   "C Standard",
      b_standard:   "B Standard",
      drop_d:       "Drop D",
      eb_drop_db:   "Eb Drop Db",
      d_drop_c:     "D Drop C",
      cs_drop_b:    "C# Drop B",
      c_drop_bb:    "C Drop Bb",
      b_drop_a:     "B Drop A"
    }

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
