# frozen_string_literal: true
require "spec_helper"

describe SongInfo::Song do
  subject { create :song }

  it { should belong_to :artist }
  it { should have_many :arrangements }
  it { should validate_presence_of :artist }
  it { should validate_presence_of :album_name }
  it { should validate_presence_of :dlc_type }
  it { should validate_presence_of :song_key }
  it { should validate_presence_of :song_length }
  it { should validate_presence_of :song_name }
  it { should validate_presence_of :song_name_sort }
  it { should validate_presence_of :song_year }
  it { should validate_uniqueness_of(:song_name).scoped_to :artist_id }
  it { should validate_uniqueness_of :song_key }

end
