include Sprig::Helpers

sprig_shared [
  SongInfo::Artist,
  SongInfo::Song,
  SongInfo::Arrangement
]

exit 0 unless Rails.env.development?
puts "Creating users..."

def create_user!(email, username, admin: false)
  return if User.find_by_email(email)
  user = User.new(
    email:                 email,
    password:              email,
    password_confirmation: email,
    username:              username,
    admin:                 admin
  )
  user.profile = Profile.new(steam_username: username)
  user.save!
end

create_user! "justin@rocksmith.dev",  "JustinAiken", admin: true
create_user! "otheruser@example.com", "OtherUser"
