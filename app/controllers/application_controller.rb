class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || default_dashboard_path
  end

  def default_dashboard_path
    if Current.user.admin?
      admin_root_path
    else
      employees_root_path
    end
  end

  def require_admin
    unless Current.user&.admin?
      flash[:alert] = "Acesso negado!"
      redirect_to employees_root_path
    end
  end

  def require_employee
    unless Current.user&.employee?
      flash[:alert] = "Acesso negado!"
      redirect_to admin_root_path
    end
  end
end
