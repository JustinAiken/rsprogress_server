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

  describe ".cdlc / .official" do
    let!(:on_disc) { create :arrangement, song: create(:song, dlc_type: :disc) }
    let!(:rs1)     { create :arrangement, song: create(:song, dlc_type: :rs1) }
    let!(:rs1_dlc) { create :arrangement, song: create(:song, dlc_type: :rs1_dlc) }
    let!(:dlc)     { create :arrangement, song: create(:song, dlc_type: :rs1_dlc) }
    let!(:cdlc)    { create :arrangement, song: create(:song, dlc_type: :cdlc) }

    it "segregates them" do
      expect(described_class.cdlc).to eq [cdlc]
      expect(described_class.official).to match_array [on_disc, rs1, rs1_dlc, dlc]
    end
  end

  describe ".guitar / .bass" do
    let!(:chords)        { create :arrangement, type: :rhythm }
    let!(:bonus_chords)  { create :arrangement, type: :bonus_rhythm }
    let!(:noodly)        { create :arrangement, type: :lead }
    let!(:bonus_noodles) { create :arrangement, type: :bonus_lead }
    let!(:bass)          { create :arrangement, type: :bass }
    let!(:moar_bass)     { create :arrangement, type: "5_string_bass" }

    it "segregates them" do
      expect(described_class.guitar).to match_array [chords, bonus_chords, noodly, bonus_noodles]
      expect(described_class.bass).to   match_array [bass, moar_bass]
    end
  end

  describe ".unplayed_by" do
    let!(:arrangement_a) { create :arrangement }
    let!(:arrangement_b) { create :arrangement }
    let!(:arrangement_c) { create :arrangement }
    let!(:player_1)      { create :user }
    let!(:player_2)      { create :user }
    let!(:prog_1_a)      { create :arrangement_progress, user: player_1, arrangement: arrangement_a }
    let!(:prog_1_c)      { create :arrangement_progress, user: player_1, arrangement: arrangement_c }

    it "returns arrangements not played by a given user" do
      expect(described_class.unplayed_by player_1).to match_array [arrangement_b]
      expect(described_class.unplayed_by player_2).to match_array [arrangement_a, arrangement_b, arrangement_c]
    end
  end
end
