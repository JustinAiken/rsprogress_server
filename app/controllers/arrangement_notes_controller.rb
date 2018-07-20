# frozen_string_literal: true

class ArrangementNotesController < ApplicationController
  before_action :authenticate_user!

  load_resource :arrangement, parent: true, class: SongInfo::Arrangement

  respond_to :json

  def create
    if arrangement_note.update(arrangement_note_params)
      render json: arrangement_note.to_json
    else
      arrangement_note.destroy if arrangement_note.persisted?
      head :error
    end
  end

private

  def arrangement_note
    @arrangement_note ||= begin
      @arrangement.arrangement_notes.find_by(user_id: current_user.id) ||
      @arrangement.arrangement_notes.build
    end
  end

  def arrangement_note_params
    params.require(:arrangement_note).permit(:body).tap do |permitted|
      permitted[:user_id] = current_user.id
    end
  end
end
