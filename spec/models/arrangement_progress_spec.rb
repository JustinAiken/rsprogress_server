# frozen_string_literal: true
require "spec_helper"

describe ArrangementProgress do
  it { should belong_to :game_progress }
  it { should belong_to :user }
  it { should belong_to :arrangement }
  it { should have_one :song }
  it { should have_one :artist }
  it { should have_many :personal_flags }

  describe ".up_to" do
    let(:up_to)                { ArrangementProgress.up_to prog_b }
    let(:user)                 { create :user }
    let!(:prog_a)              { create :game_progress, user: user, ended_at: DateTime.current - 2.days, steam_mins: 100  }
    let!(:prog_b)              { create :game_progress, user: user, ended_at: DateTime.current - 1.days, steam_mins: 150  }
    let!(:other_prog)          { create :game_progress, user: create(:user), ended_at: DateTime.current - 2.days, steam_mins: 250  }
    let!(:arr_easy)            { create :arrangement }
    let!(:arr_hard)            { create :arrangement }
    let!(:arr_easy_progress_1) { create :arrangement_progress, arrangement: arr_easy, game_progress: prog_a }
    let!(:other_arr_prog)      { create :arrangement_progress, arrangement: arr_easy, game_progress: other_prog }
    let!(:arr_hard_progress_1) { create :arrangement_progress, arrangement: arr_hard, game_progress: prog_a, mastery: 0.5 }
    let!(:arr_hard_progress_2) { create :arrangement_progress, arrangement: arr_hard, game_progress: prog_b, mastery: 0.6 }

    it "loads the right fucking arrangements" do
      expect(up_to.pluck :id).to match_array [arr_easy_progress_1.id, arr_hard_progress_2.id]
    end
  end

  describe "#no_progress?" do
    let(:user)                 { create :user }
    let!(:prog_a)              { create :game_progress, user: user, ended_at: DateTime.current - 2.days, steam_mins: 100  }
    let!(:prog_b)              { create :game_progress, user: user, ended_at: DateTime.current - 1.days, steam_mins: 150  }
    let!(:other_prog)          { create :game_progress, user: create(:user), ended_at: DateTime.current - 2.days, steam_mins: 250  }
    let!(:arr_easy)            { create :arrangement }
    let!(:arr_hard)            { create :arrangement }
    let!(:arr_easy_progress_1) { create :arrangement_progress, arrangement: arr_easy, game_progress: prog_a }
    let!(:other_arr_prog)      { create :arrangement_progress, arrangement: arr_hard, game_progress: other_prog }
    let!(:arr_hard_progress_1) { create :arrangement_progress, arrangement: arr_hard, game_progress: prog_a, mastery: 0.5, user_id: user.id }
    let!(:arr_hard_progress_2) { build  :arrangement_progress, arrangement: arr_hard, game_progress: prog_b, mastery: 0.5, user_id: user.id }

    it "is correct" do
      expect(arr_hard_progress_1).not_to be_no_progress
      expect(arr_hard_progress_2).to     be_no_progress
    end
  end
end

# reload! last = ArrangementProgress.last; first = last.previous_progress
