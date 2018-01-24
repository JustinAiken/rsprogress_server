module SongInfo
  class ArrangementData < ActiveRecord::Base
    belongs_to :arrangement, inverse_of: :arrangement_data

    validates_presence_of :arrangement, :data
  end
end
