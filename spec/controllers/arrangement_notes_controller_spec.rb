# frozen_string_literal: true
require "spec_helper"

describe ArrangementNotesController do
  describe "POST :create", :authorized_user do
    let(:arrangement) { create :arrangement }
    let(:created)     { ArrangementNote.last }
    let(:make_post)   { post :create, params: params.merge(arrangement_id: arrangement.id), format: :json }

    context "with basic params" do
      let(:params) { {arrangement_note: { body: "oh hi" }} }

      it "creates" do
        expect { make_post }.to change { ArrangementNote.count }.by 1
        expect(created.user_id).to        eq user.id
        expect(created.body).to           eq "oh hi"
        expect(created.arrangement_id).to eq arrangement.id
      end

      context "when a note already exists" do
        let!(:existing) { create :arrangement_note, arrangement: arrangement, body: "old", user: user }

        it "doesn't create a new" do
          expect { make_post }.not_to change { ArrangementNote.count }
        end

        it "updates it" do
          expect { make_post }.to change { existing.reload.body }.to "oh hi"
        end

        context "and blank params are passed" do
          let(:params) { {arrangement_note: { body: "" }} }

          it "deletes it" do
            expect { make_post }.to change { ArrangementNote.count }.by -1
          end

          it "clears the arrangement_progresses cache" do
            ap = create :arrangement_progress, arrangement: arrangement, user: user
            expect(Rails.cache).to receive(:delete).with "flag_notes/#{user.id}"
            expect(Rails.cache).to receive(:delete).with "arrangement_progresses/#{user.id}/#{ap.id}"
            make_post
          end
        end
      end
    end
  end
end
