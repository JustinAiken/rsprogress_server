module API
  class FlagsController < ApplicationController

    load_resource :arrangement, class: "SongInfo::Arrangement", find_by: :identifier, only: :create

    actions :index, :create

    defaults resource_class: PersonalFlag, collection_name: :personal_flags, instance_name: :personal_flag

  private

    def begin_of_association_chain
      current_user
    end

    def end_of_association_chain
      super.includes arrangement: {song: :artist}
    end

    def collection
      super.map do |flag|
        {
          id:          flag.arrangement.identifier,
          name:        flag.arrangement.to_s,
          happened_at: flag.happened_at
        }
      end
    end

    def build_resource
      return super unless existing
      existing.assign_attributes personal_flag_params
      existing
    end

    def personal_flag_params
      params.require(:personal_flag).permit(:happened_at).tap do |permitted|
        permitted[:arrangement_id] = @arrangement.id
      end
    end

    def existing
      @existing ||= PersonalFlag.find_by(user_id: current_user.id, arrangement_id: @arrangement.id)
    end
  end
end
