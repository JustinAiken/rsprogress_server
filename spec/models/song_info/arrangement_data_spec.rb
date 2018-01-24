# frozen_string_literal: true
require "spec_helper"

describe SongInfo::ArrangementData do
  it { should belong_to :arrangement }

  it { should validate_presence_of :arrangement }
  it { should validate_presence_of :data }
end
