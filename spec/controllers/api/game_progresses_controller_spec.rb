# frozen_string_literal: true
require "spec_helper"

describe API::GameProgressesController do
  describe "POST :create", :authorized_user do
    let(:make_post!)      { post :create, format: :json, params: {game_progress: params} }
    let(:params)          { {steam_mins: 100, ended_at: DateTime.current, arrangement_progresses_attributes: ap_params} }
    let(:ap_params)       { [unplayed, some_progress] }
    let(:unplayed)        { {"identifier" => create(:arrangement).identifier } }
    let(:some_progress)   { {"identifier" => create(:arrangement).identifier, "sa_play_count" => 1, "play_count" => 1 } }
    let(:created_gp)      { GameProgress.last }

    it "creates a new game progress" do
      expect {
        make_post!
        expect(response).to be_success
      }.to change { user.game_progresses.count }.by 1
      expect(created_gp.user).to       eq user
      expect(created_gp.steam_mins).to eq 100
    end
  end
end
