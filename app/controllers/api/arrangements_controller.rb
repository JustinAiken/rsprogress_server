module API
  class ArrangementsController < ApplicationController

    actions :show, :create

    defaults resource_class: SongInfo::Arrangement

  private

    def arrangement_params
      params.require(:arrangement).permit :dlc_type, raw_json: {}
    end
  end
end
