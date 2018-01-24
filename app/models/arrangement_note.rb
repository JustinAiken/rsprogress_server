class ArrangementNote <  ActiveRecord::Base
  include InvalidatesFlagNoteCache

  belongs_to :user
  belongs_to :arrangement, class_name: "SongInfo::Arrangement"

  validates_presence_of :user, :arrangement, :body
  validates_uniqueness_of :user_id, scope: :arrangement_id
end
