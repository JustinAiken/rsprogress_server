# frozen_string_literal: true
require "spec_helper"

describe API::FlagsController do
  describe "GET :index unauthorized", authorized_user: nil do
    it "401's" do
      get :index, format: :json
      expect(response.code).to eq "401"
    end
  end

  describe "GET :index", :authorized_user do
    let!(:my_flag)    { create :personal_flag, user: user }
    let!(:other_flag) { create :personal_flag }

    it "picks the right flag" do
      get :index, format: :json
      expect(assigns[:personal_flags].pluck :id).to include my_flag.id
      expect(assigns[:personal_flags].pluck :id).not_to include other_flag.id
    end

    it "renders the JSON" do
      get :index, format: :json
      expect(json_response[0]["id"]).to         eq my_flag.arrangement.identifier
      expect(json_response[0]["happened_at"]).to be_present
      expect(json_response[0]["name"]).to        be_present
    end
  end

  describe "POST :create", :authorized_user do
    let(:make_post!)   { post :create, format: :json, params: {arrangement_id: "abcd", personal_flag: flag_params} }
    let(:flag)         { PersonalFlag.last }
    let!(:arrangement) { create :arrangement, identifier: "abcd" }

    context "new flag" do
      let(:flag_params) { {happened_at: "2017-01-01"} }

      it "creates a new flag" do
        expect {
          make_post!
        }.to change { user.personal_flags.count }.by 1
        expect(flag.user).to             eq user
        expect(flag.arrangement).to      eq arrangement
        expect(flag.happened_at.year).to eq 2017
      end

      context "with an existing" do
        let!(:existing) { create :personal_flag, user: user, arrangement: arrangement, happened_at: Date.new(2016,1,1) }

        it "doesn't create a new one" do
          expect {
            make_post!
          }.not_to change { user.personal_flags.count }
        end

        it "updates the happened_at on the existing" do
          expect {
            make_post!
          }.to change { existing.reload.happened_at.year
          }.from(2016).to 2017
        end

        context "and no changes" do
          let(:flag_params) { {happened_at: "2016-01-01"} }

          it "doesn't change a thing" do
            expect {
              make_post!
            }.not_to change { existing.reload }
            expect(PersonalFlag.count).to eq 1
          end
        end
      end
    end
  end
end
