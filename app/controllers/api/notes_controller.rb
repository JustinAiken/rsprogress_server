# frozen_string_literal: true

module API
  class NotesController < ApplicationController

    load_resource :arrangement, class: "SongInfo::Arrangement", find_by: :identifier, only: :create

    actions :index, :create

    defaults resource_class: ArrangementNote, collection_name: :arrangement_notes, instance_name: :arrangement_note

  private

    def begin_of_association_chain
      current_user
    end

    def end_of_association_chain
      super.includes arrangement: {song: :artist}
    end

    def collection
      super.map do |note|
        {
          id:          note.arrangement.identifier,
          name:        note.arrangement.to_s,
          body:        note.body
        }
      end
    end

    def build_resource
      return super unless existing
      existing.assign_attributes arrangement_note_params
      existing
    end

    def arrangement_note_params
      params.require(:arrangement_note).permit(:body).tap do |permitted|
        permitted[:arrangement_id] = @arrangement.id
      end
    end

    def existing
      @existing ||= ArrangementNote.find_by(user_id: current_user.id, arrangement_id: @arrangement.id)
    end
  end
end
