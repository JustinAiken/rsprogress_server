# frozen_string_literal: true

class ArrangementDetailer

  def self.detail!(arrangement)
    arr = self.new(arrangement)
    arr.detail
    arr.save!
  end

  delegate :data, :song, to: :arrangement

  attr_accessor :arrangement

  def initialize(arrangement)
    @arrangement = arrangement
  end

  def detail
    arrangement.difficulty       = data['SongDifficulty']
    arrangement.tuning           = tuning
    arrangement.tuning_offset    = tuning_offset
    arrangement.capo             = capo
    arrangement.type             = parse_arrangement_type
  end

  def save!
    if arrangement.type.nil?
      puts "warning - no arrangement type for #{arrangement}"
    else
      arrangement.save!
    end
  end

private

  def parse_arrangement_type
    return "5_string_bass" if five_string_bass?

    a_represent = arrangement_properties['represent']
    is_bonus    = arrangement_properties['bonusArr']
    is_lead     = arrangement_properties['pathLead']
    is_bass     = arrangement_properties['pathBass']
    is_rhy      = arrangement_properties['pathRhythm']

    case [a_represent, is_bonus, is_lead, is_rhy, is_bass]
    when [1,           0,        1,       0,      0] then :lead
    when [1,           0,        0,       1,      0] then :rhythm
    when [0,           1,        1,       0,      0] then :bonus_lead
    when [0,           0,        1,       0,      0] then :alternate_lead
    when [0,           0,        0,       1,      0] then :alternate_rhythm
    when [0,           1,        0,       1,      0] then :bonus_rhythm
    when [1,           0,        0,       0,      1] then :bass
    when [0,           0,        0,       0,      1] then :alternate_bass
    when [0,           1,        0,       0,      1] then :alternate_bass
    end
  end

  TUNINGS = {
    [1,1,1,1,1,1]       => "F Standard",
    [0,0,0,0,0,0]       => "E Standard",
    [-2,0,0,0,0,0]      => "Drop D",
    [-1,-1,-1,-1,-1,-1] => "Eb Standard",
    [-3,-1,-1,-1,-1,-1] => "Eb Drop Db",
    [-2,-2,-2,-2,-2,-2] => "D Standard",
    [-4,-2,-2,-2,-2,-2] => "D Drop C",
    [-3,-3,-3,-3,-3,-3] => "C# Standard",
    [-5,-3,-3,-3,-3,-3] => "C# Drop B",
    [-4,-4,-4,-4,-4,-4] => "C Standard",
    [-5,-5,-5,-5,-5,-5] => "B Standard",
    [-7,-5,-5,-5,-5,-5] => "B Drop A"
  }

  def tuning
    t       = data['Tuning']
    strings = [t['string0'], t['string1'], t['string2'], t['string3'], t['string4'], t['string5']]

    TUNINGS[strings] || "Custom"
  end

  A440 = 440.0

  def tuning_offset
    cents  = data['CentOffset']
    freq   = (A440 * (2.0 ** (cents / 1200.0))).to_i
    return nil if freq == 440
    freq
  end

  def capo
    return nil if data["CapoFret"].in? [0, "0"]
    data["CapoFret"]
  end

  def five_string_bass?
    return false unless song.present?
    return false unless song.dlc_type == "cdlc"              # Only customs have 5 string bass
    return false if     data['ArrangementName']   == "Bass"  # And they're never labeled "Bass"
    return false unless data['Tuning']['string4'] == data['Tuning']['string5']

    # Any tones called bass?
    return false unless data['Tones'].any? do |tone_data|
      tone_data['Key'] =~ /Bass/i || tone_data['Name'] =~ /Bass/i
    end

    true
  end

  def arrangement_properties
    data["ArrangementProperties"]
  end
end
