module RailsAdmin
  module Config
    module Actions
      class RoleSetter < RailsAdmin::Config::Actions::Base
        register_instance_option :member do
          true
        end

        register_instance_option :controller do
          proc do
            @object = User.find(params[:id])

            # TODO: if logic will be more complex, move to service
            if current_user == @object
              flash[:alert] = 'Can\'t change for yourself'
            elsif @object.admin?
              @object.user!
              flash[:success] = 'Marked as user'
            else
              @object.admin!
              @object.update(admin_set_by_id: current_user.id)

              flash[:success] = 'Marked as admin'
            end

            redirect_to rails_admin.index_path('user')
          end
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :link_icon do
          bindings[:object].admin? ? 'fa fa-ban' : 'fa fa-check-circle'
        end

        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end
