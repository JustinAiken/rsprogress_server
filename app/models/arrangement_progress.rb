class ArrangementProgress <  ActiveRecord::Base
  belongs_to :game_progress, inverse_of: :arrangement_progresses
  belongs_to :user

  belongs_to :arrangement, class_name: "SongInfo::Arrangement"
  has_one :song,   through: :arrangement, class_name: "SongInfo::Song"
  has_one :artist, through: :arrangement, class_name: "SongInfo::Artist"

  has_many :personal_flags, through: :arrangement

  attr_accessor :identifier

  validates_presence_of :game_progress

  before_validation :set_arrangement
  before_validation :set_user_id
  before_validation :set_steam_mins

  MASSIVELY_FUCKING_UGLY_SQL = <<~SQL
    arrangement_progresses.id IN (
      SELECT
        arrangement_progresses.id
      FROM arrangement_progresses
      INNER JOIN (
        SELECT arrangement_id, MAX(steam_mins) AS max_mins
        FROM arrangement_progresses
        WHERE arrangement_progresses.user_id = ?
        GROUP BY arrangement_id
      ) ap ON (
        arrangement_progresses.arrangement_id = ap.arrangement_id
        AND arrangement_progresses.steam_mins = ap.max_mins
      )
    )
  SQL

  scope :up_to, -> (gp) { where MASSIVELY_FUCKING_UGLY_SQL, gp.user_id }

  PICKS = {
    fail:      1,
    bronze:    2,
    silver:    3,
    gold:      4,
    platinum:  5
  }

  %i{easy medium hard master}.each do |difficulty|
    enum "sa_pick_#{difficulty}".to_sym => PICKS.inject({}) { |memo, (key, value)| memo["sa_pick_#{difficulty}_#{key}"] = value; memo }
  end

  validate do
    errors.add :base, "Not played"  if (play_count.to_i == 0 && sa_play_count.to_i == 0)
    errors.add :base, "No progress" if no_progress?
  end

  def to_s
    "#{artist.artist_name} - #{song.song_name} - #{arrangement.type} - #{play_count} - #{mastery} - #{streak}"
  end

  def no_progress?
    like_self
      .where(play_count:    play_count)
      .where(mastery:       mastery)
      .where(date_sa:       date_sa)
      .where(date_las:      date_las)
      .where(streak:        streak)
      .exists?
  end

  def previous_progresses
    if arrangement.arrangement_progresses.loaded?
      arrangement
        .arrangement_progresses
        .select { |ap| ap.steam_mins < steam_mins }
        .sort_by(&:steam_mins)
        .reverse
    else
      like_self
        .where("steam_mins < ?", steam_mins)
        .order "steam_mins DESC"
    end
  end

  def previous_progress
    previous_progresses.first
  end

  def diffs
    ArrangementProgressDiffer.new(self).diffs
  end

private

  def like_self
    base_q = self.class
      .where(user_id: user_id)
      .where(arrangement_id: arrangement_id)

    if self.id.present?
      base_q.where.not(id: self.id)
    else
      base_q
    end
  end

  def set_arrangement
    self.arrangement ||= SongInfo::Arrangement.find_by_identifier(self.identifier)
  end

  def set_user_id
    self.user_id ||= game_progress.user_id
  end

  def set_steam_mins
    self.steam_mins ||= game_progress.steam_mins
  end
end
