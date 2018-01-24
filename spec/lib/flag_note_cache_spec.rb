# frozen_string_literal: true
require "spec_helper"

describe FlagNoteCache do
  let(:flag_note_cache) { described_class.new user.id }
  let(:user)            { build_stubbed :user, id: 123 }

  describe ".[]" do
    pending
  end

  describe "#retrieve!" do
    pending
  end
end
