require_relative 'generic_page'

class UserPortalPage < GenericPage
  def login(user_name, password)
    find("input[placeholder='E-mail']").set user_name
    find("input[placeholder='Password']").set password
    sleep 3
  end
end
