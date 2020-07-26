require_relative 'generic_page'

class AdminPortalPage < GenericPage
  def login(user_name, password)
    find("input[placeholder='Username']").set user_name
    find("input[placeholder='Password']").set password
    click_button 'Sign in'
  end

  def sign_up(role)
    execution_data.user_info = user_info role
    find("div[class='create']", :text => 'Create account').click

    find("input[placeholder='Full name']").set execution_data.user_info["Full name"]
    find("input[placeholder='E-mail']").set execution_data.user_info["Email address"]
    find("input[placeholder='Country']").click
    find("ul[class='el-scrollbar__view el-select-dropdown__list'] > li > span", :text => execution_data.user_info["Country"]).select_option
    find("input[placeholder='company']").click
    find("ul[class='el-scrollbar__view el-select-dropdown__list'] > li > span", :text => execution_data.user_info["Company"]).select_option
    find("input[placeholder='Password']").set execution_data.user_info["Password"]
    find("input[placeholder='Confirm Password']").set execution_data.user_info["Password"]
    find("div[class='content'] > p[class='circle']").click
    find("div[class='submit']", :text => 'Sign up').click
  end

  def approve_new_user
    find('span', :text => 'Member').click

    execution_data.user_info = user_info 'AutomationRequester'

    within_visible_frame do
      find("button[name='commonSearch']").click
      find("input[id='email']").set execution_data.user_info["Email address"]
      # find("input[id='email']").set 'automation_test@lecoov.com'
      click_button 'Submit'
      find("ul[class='nav nav-tabs'] > li", :text => 'Check').click
      # find("ul[class='nav nav-tabs'] > li", :text => 'Pass').click
      find("td > a", :text => /operate/).click
      within_visible_frame do
        find("td[id='status'] > input[id='Pass']").click
      end
      find('button', :text => 'Close').click rescue nil
    end
    find("li[class='dropdown user user-menu'] > a > span", :text => 'Admin').click
    find("i[class='fa fa-sign-out']").click
  end

end
