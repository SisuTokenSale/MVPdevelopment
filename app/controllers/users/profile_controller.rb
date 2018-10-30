module Users
  class ProfileController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile, only: %i[index update]

    def index; end

    def update
      if @profile.update(profile_params)
        redirect_to dashboard_index_path, notice: 'Profile successfully updated'
      else
        render :index
      end
    end

    private

    def set_profile
      @profile = current_user.profile || current_user.build_profile
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :street, :city,
                                      :state, :zip, :birth_date, :documents, :ssn)
    end
  end
end
