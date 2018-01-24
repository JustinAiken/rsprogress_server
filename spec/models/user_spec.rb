# frozen_string_literal: true
require "spec_helper"

describe User do
  it { should have_many :game_progresses }
  it { should have_many :arrangement_progresses }
  it { should have_many :arrangement_notes }
  it { should have_many :personal_flags }
  it { should have_one  :profile }

  describe "#create_profile" do
    let(:user) { build :user }

    it "creates a profile" do
      expect { user.save! }.to change { Profile.count }.by 1
      expect(user.profile).to be_present
    end
  end
end
