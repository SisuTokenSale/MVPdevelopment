module Users
  class ProfileController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile, only: %i[index create update status]

    def index; end

    def create
      if @profile.update(profile_params)
        DwollaRegisterProfileCustomersJob.perform_later(id: @profile.id)
        redirect_to users_profile_index_path, notice: 'Profile successfully updated'
      else
        render :index
      end
    end

    def update
      if @profile.update(profile_params)
        DwollaUpdateProfileCustomersJob.perform_later(id: @profile.id)
        redirect_to users_profile_index_path, notice: 'Profile successfully updated'
      else
        render :index
      end
    end

    def status
      render json: { profile: { status: @profile.status } }.to_json
    end

    private

    def set_profile
      @profile = current_user.profile || current_user.build_profile
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :street, :city,
                                      :state, :zip, :dob, :document, :ssn)
    end
  end
end
