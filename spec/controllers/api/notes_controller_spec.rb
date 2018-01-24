# frozen_string_literal: true
require "spec_helper"

describe API::NotesController do
  describe "GET :index unauthorized", authorized_user: nil do
    it "401's" do
      get :index, format: :json
      expect(response.code).to eq "401"
    end
  end

  describe "GET :index", :authorized_user do
    let!(:my_note)      { create :arrangement_note, user: user, body: "Foo" }
    let!(:other_note)   { create :arrangement_note }

    it "picks the right note" do
      get :index, format: :json
      expect(assigns[:arrangement_notes].pluck :id).to     include my_note.id
      expect(assigns[:arrangement_notes].pluck :id).not_to include other_note.id
    end

    it "renders the JSON" do
      get :index, format: :json
      expect(json_response[0]["id"]).to   eq my_note.arrangement.identifier
      expect(json_response[0]["body"]).to eq "Foo"
      expect(json_response[0]["name"]).to be_present
    end
  end

  describe "POST :create", :authorized_user do
    let(:make_post!)   { post :create, format: :json, params: {arrangement_id: "abcd", arrangement_note: note_params} }
    let(:note)         { ArrangementNote.last }
    let!(:arrangement) { create :arrangement, identifier: "abcd" }

    context "new note" do
      let(:note_params) { {body: "foo"} }

      it "creates a new note" do
        expect {
          make_post!
        }.to change { user.arrangement_notes.count }.by 1
        expect(note.user).to             eq user
        expect(note.arrangement).to      eq arrangement
        expect(note.body).to             eq "foo"
      end

      context "with an existing" do
        let!(:existing) { create :arrangement_note, user: user, arrangement: arrangement, body: "old" }

        it "doesn't create a new one" do
          expect {
            make_post!
          }.not_to change { user.arrangement_notes.count }
        end

        it "updates the body on the existing" do
          expect {
            make_post!
          }.to change { existing.reload.body
          }.from("old").to "foo"
        end

        context "and no changes" do
          let(:note_params) { {body: "old"} }

          it "doesn't change a thing" do
            expect {
              make_post!
            }.not_to change { existing.reload }
            expect(ArrangementNote.count).to eq 1
          end
        end
      end
    end
  end
end
