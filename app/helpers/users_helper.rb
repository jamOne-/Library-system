module UsersHelper
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    # True if user logged in and is admin
    def admin?
      logged_in? && current_user.admin?
    end
end
