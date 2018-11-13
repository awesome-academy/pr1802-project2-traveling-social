RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancancan
  config.parent_controller = 'ApplicationController'

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard do
      statistics false
    end        
    index
    new do
      except %w(MicroPost Event Comment Review)
    end
    export
    bulk_delete
    show
    edit do
      except %w(MicroPost Event Comment Review)
    end
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model Ckeditor::Asset do
    visible false
  end

  config.model Ckeditor::AttachmentFile do
    visible false
  end

  config.model Ckeditor::Picture do
    visible false
  end

  config.model Location do
    navigation_icon 'icon-road'
    list do
      field :name
      field :porpular
      field :thumbnail
      field :city
      field :slug
      field :created_at
    end
    edit do
      field :name
      field :porpular
      field :city
      field :address, :google_map do
        default_latitude 21.027842
        default_longitude 105.833913
        locale 'en'
      end
      field :description, :ck_editor
      field :thumbnail
      field :images
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end
  end

  config.model City do
    navigation_icon 'icon-home'
    list do
      field :name
      field :thumbnail
      field :slug
      field :created_at
    end
    edit do
      field :name
      field :address, :google_map do
        default_latitude 21.027842
        default_longitude 105.833913
        locale 'en'
      end
      field :description, :ck_editor
      field :thumbnail
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end
  end

  config.model Comment do
    navigation_icon 'icon-comment'
  end

  config.model User do
    navigation_icon 'icon-user'
  end

  config.model Event do
    navigation_icon 'icon-calendar'
  end

  config.model Review do
    navigation_icon 'icon-folder-open'
  end

  config.model UserEvent do
    visible false
  end

  config.model Follow do
    visible false
  end

  config.model Image do
    visible false
  end

  config.model Role do
    visible false
  end

  config.model Punch do
    visible false
  end

  config.model Rate do
    visible false
  end

  config.model RatingCache do
    visible false
  end

  config.model OverallAverage do
    visible false
  end

  config.model MicroPost do
    label "Status" 
    label_plural "Status"
    navigation_icon 'icon-file'
  end
end
