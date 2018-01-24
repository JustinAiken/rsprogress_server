class GameProgress <  ActiveRecord::Base
  belongs_to :user
  has_many :arrangement_progresses, inverse_of: :game_progress, dependent: :destroy

  accepts_nested_attributes_for :arrangement_progresses, reject_if: ->(attributes) {
    !SongInfo::Arrangement.where(identifier: attributes["identifier"]).exists?
  }

  before_validation do
    self.arrangement_progresses.to_a.each do |arrangement_progress|
      arrangement_progress.game_progress = self
      arrangement_progress.user_id       = self.user_id
      arrangement_progress.steam_mins    = self.steam_mins
      self.arrangement_progresses.delete(arrangement_progress) unless arrangement_progress.valid?
    end
  end

  validate do
    errors.add :base, "No progress" if no_progress?
  end

  def previous_session
    @previous_session ||= GameProgress
      .where(user_id: user_id)
      .where("steam_mins < ?", steam_mins)
      .order(steam_mins: :desc)
      .first
  end

  def self.report_all!
    GameProgress
      .includes(:arrangement_progresses)
      .order(steam_mins: :asc)
      .all
      .map { |gp| gp.display_report }
  end

  def duration
    return nil unless previous_session
    steam_mins - previous_session.steam_mins
  end

  def started_at
    ended_at - duration.minutes
  end

  def no_progress?
    GameProgress.where(
      steam_mins: steam_mins,
      ended_at:   ended_at,
      user_id:    user_id
    ).exists?
  end

  def display_report
    verbose_report.split("\n").each do |line|
      puts line
    end
    puts " "
  end

  def verbose_report
    return "" unless previous_session

    vr = ["GameProgress #{id}: #{duration} minute session ending at #{ended_at}"]
    if arrangement_progresses.count < 50
      arrangement_progresses.each do |ap|
        vr << "  #{ap.artist.artist_name} - #{ap.song.song_name} - #{ap.arrangement.type} #{ap.arrangement.identifier}"
        ArrangementProgressDiffer.new(ap, presenter_klass: ArrangementProgressStringPresenter).diffs.each do |key, changes|
          label = key
          from  = changes[0]
          to    = changes[1]
          if from.nil?
            change = "To #{to}"
          else
            change = "From #{from} to #{to}"
          end
          vr << "    #{label}: #{change}"
        end
      end
    end
    vr
  end
end
