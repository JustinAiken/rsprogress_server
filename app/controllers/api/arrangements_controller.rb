# frozen_string_literal: true

module API
  class ArrangementsController < ApplicationController

    actions :show, :create, :update

    defaults resource_class: SongInfo::Arrangement

    def update
      @arrangement = SongInfo::Arrangement.find_by_identifier(params[:id])
      update!
    end

  private

    def arrangement_params
      params.require(:arrangement).permit :dlc_type, raw_json: {}
    end
  end
end
