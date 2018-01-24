class User <  ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable

  has_many :game_progresses
  has_many :arrangement_progresses, through: :game_progresses
  has_many :arrangement_notes
  has_many :personal_flags
  has_one  :profile, inverse_of: :user

  delegate :steam_id, to: :profile

  after_create :create_profile

  def total_hours
    game_progresses
      .order(steam_mins: :desc)
      .limit(1)
      .pluck(:steam_mins)[0] / 60
  rescue
    "?"
  end

private

  def create_profile
    self.build_profile.save!
  end
end
