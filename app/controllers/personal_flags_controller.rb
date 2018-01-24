class PersonalFlagsController < ApplicationController
  before_action :authenticate_user!

  load_resource :arrangement, parent: true, class: SongInfo::Arrangement

  respond_to :json

  def create
    personal_flag.update_attributes personal_flag_params
    if personal_flag.fc == "true"
      personal_flag.save
      render json: personal_flag.to_json
    else
      personal_flag.destroy if personal_flag.persisted?
      head :error
    end
  end

private

  def personal_flag
    @personal_flag ||= begin
      @arrangement.personal_flags.find_by(user_id: current_user.id) ||
      @arrangement.personal_flags.build
    end
  end

  def personal_flag_params
    params.require(:personal_flag).permit(:fc, :happened_at).tap do |permitted|
      permitted[:user_id] = current_user.id
    end
  end
end
