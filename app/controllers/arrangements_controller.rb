# frozen_string_literal: true

class ArrangementsController < ApplicationController
  before_action :authenticate_user!

  load_resource

  def show
    @arrangement      = @arrangement_progress.arrangement
    @arrangement_note = current_user.arrangement_notes.where(arrangement_id: @arrangement.id).first || current_user.arrangement_notes.new(arrangement_id: @arrangement.id)
    render layout: false
  end
end
