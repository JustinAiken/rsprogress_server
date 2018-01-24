# frozen_string_literal: true
require "spec_helper"

describe SongInfo::Artist do
  it { should have_many :songs }
  it { should have_many :arrangements }

  it { should validate_presence_of :artist_name }
  it { should validate_presence_of :artist_name_sort }
  it { should validate_uniqueness_of :artist_name }
end
