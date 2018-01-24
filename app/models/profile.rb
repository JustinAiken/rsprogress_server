class Profile <  ActiveRecord::Base
  belongs_to :user, inverse_of: :profile

  before_save :update_steam_id, if: :steam_username

private

  def update_steam_id
    self.steam_id ||= Steam::User.vanity_to_steamid(self.steam_username)
  end
end
