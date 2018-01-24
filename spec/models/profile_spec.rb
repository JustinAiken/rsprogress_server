# frozen_string_literal: true
require "spec_helper"

describe Profile do
  it { should belong_to :user }

  describe "#update_steam_id" do
    context "with steam_id_set" do
      let(:profile)  { build :profile, steam_id: 123 }

      it "does nothing" do
        expect(Steam::User).not_to receive :vanity_to_steamid
        profile.save!
        expect(profile.steam_id).to eq "123"
      end
    end

    context "with steam_id_set not set, but steam_username set" do
      let(:profile)  { build :profile, steam_id: nil, steam_username: "FooBar" }

      it "does nothing" do
        expect(Steam::User).to receive(:vanity_to_steamid).with("FooBar").and_return 456
        profile.save!
        expect(profile.steam_id).to eq "456"
      end
    end
  end
end
