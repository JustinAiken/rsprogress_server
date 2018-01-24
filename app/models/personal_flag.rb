class PersonalFlag <  ActiveRecord::Base
  include InvalidatesFlagNoteCache

  belongs_to :arrangement, class_name: "SongInfo::Arrangement"
  belongs_to :user

  attr_accessor :fc
end
