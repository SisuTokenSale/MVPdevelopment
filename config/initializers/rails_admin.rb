require Rails.root.join('lib', 'rails_admin', 'role_setter.rb')
require Rails.root.join('lib', 'rails_admin', 'dashboard.rb')

RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::RoleSetter)

RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  config.current_user_method(&:current_user)

  config.included_models = %w[User Event DwollaWebhook]

  config.main_app_name = %w[Admin Panel]
  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      only ['DwollaWebhook']
    end

    export do
      only ['User']
    end
    # bulk_delete
    show
    edit do
      only ['User']
    end

    delete do
      only ['DwollaWebhook']
    end
    # delete
    show_in_app
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model DwollaWebhook do
    list do
      field :url
      field :active?
      field :dwolla_registered?
      field :created_at
      field :updated_at
      field :current?
    end

    show do
      field :url
      field :active?
      field :dwolla_registered?
      field :created_at
      field :updated_at
      field :current?
    end

    edit do
      field :url
      field :secret
    end
  end

  config.model User do
    export do
      field :first_name
      field :last_name
      field :email
    end

    list do
      field :email
      field :role
      field :last_sign_in_at
      field :last_sign_in_ip
      field :confirmed_at
    end

    show do
      field :role
      field :email
      field :last_sign_in_at
      field :last_sign_in_ip
      field :confirmed_at
    end

    edit do
      field :role
    end
  end

  config.model Event do
    list do
      field :object_class
      field :status
      field :topic
      field :uid
      field :created_at
    end
  end
end
