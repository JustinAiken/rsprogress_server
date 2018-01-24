# frozen_string_literal: true
require "spec_helper"

describe GameProgress do
  it { should belong_to :user }
  it { should have_many :arrangement_progresses }

  describe "#previous_session" do
    let!(:user)       { create :user }
    let!(:other_user) { create :user }
    let!(:yesterday)  { create :game_progress, steam_mins:  50, user: user }
    let!(:other_ses)  { create :game_progress, steam_mins:  60, user: other_user }
    let!(:today)      { create :game_progress, steam_mins: 100, user: user }

    it "gets the last" do
      expect(yesterday.previous_session).to eq nil
      expect(today.previous_session).to     eq yesterday
    end
  end
end
