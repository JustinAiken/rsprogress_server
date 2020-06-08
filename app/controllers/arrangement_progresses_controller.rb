# frozen_string_literal: true

class ArrangementProgressesController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :game_progress,         only: :index
  load_and_authorize_resource through: :current_user, only: :show

  def index
    respond_to do |format|
      format.json do
        render json: ArrangementProgressDatatable.new(params, view_context: view_context, game_progress: @game_progress)
      end
    end
  end

  def show
    @arrangement      = @arrangement_progress.arrangement
    @arrangement_note = current_user.arrangement_notes.where(arrangement_id: @arrangement.id).first || current_user.arrangement_notes.new(arrangement_id: @arrangement.id)
    @personal_flag    = current_user.personal_flags.where(arrangement_id: @arrangement.id).first || current_user.personal_flags.new(arrangement_id: @arrangement.id)
    @personal_flag.fc = true if @personal_flag.persisted?
    render layout: false
  end
end
