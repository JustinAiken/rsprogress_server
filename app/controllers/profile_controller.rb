class ProfileController < ApplicationController

  before_action :authenticate_user!

  load_resource through: :current_user, singleton: true

  def show
    @current_progress = current_user.game_progresses.last
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, flash: {notice: "Successfully updated profile!"}
    else
      render :edit, flash: "Error!"
    end
  end

private

  def profile_params
    params.require(:profile).permit :steam_username, :public
  end
end
