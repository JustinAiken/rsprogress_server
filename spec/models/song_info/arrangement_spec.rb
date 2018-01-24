# frozen_string_literal: true
require "spec_helper"

describe SongInfo::Arrangement do
  subject { create :arrangement }

  it { should belong_to :song }
  it { should have_one :artist }
  it { should have_many :arrangement_progresses }
  it { should have_many :arrangement_notes }
  it { should have_one :arrangement_data }
  it { should have_many :personal_flags }
  it { should validate_presence_of :identifier }
  it { should validate_presence_of :type }
  it { should validate_presence_of :difficulty }
  it { should validate_uniqueness_of :identifier }
end
