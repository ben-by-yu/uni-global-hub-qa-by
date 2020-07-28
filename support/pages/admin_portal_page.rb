require_relative 'generic_page'
require_relative '../models/db_query'

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
    find("input[placeholder='Company']").click
    find("ul[class='el-scrollbar__view el-select-dropdown__list'] > li > span", :text => execution_data.user_info["Company"]).select_option
    find("input[placeholder='Password']").set execution_data.user_info["Password"]
    find("input[placeholder='Confirm Password']").set execution_data.user_info["Password"]
    find("div[class='content'] > p[class='circle']").click
    find("div[class='submit']", :text => 'Sign up').click
  end

  def approve_new_user
    execute_with_retry 10 do
      find('span', :text => 'Member').click
    end

    execution_data.user_info = user_info 'AutomationRequester'
    sleep 2
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

  def add_item(section_name)
    thumbnail_path = ''
    downloadable_pdf_path = ''
    puts thumbnail_path
    within_visible_frame do
      find(:xpath, "//td[contains(., '#{section_name}')]/../td/a[contains(., 'Add Items')]").click
      within_visible_frame do
        # Retrieve thumbnail and pdf path from existing item
        first("table[id='table'] > tbody > tr > td > a > i[class='fa fa-pencil']").click
        within_visible_frame do
          thumbnail_path = find("input[id='c-images']")[:value]
          downloadable_pdf_path = find("input[id='c-document']")[:value]
          # find("span[class='layui-layer-setwin'] > a[class='layui-layer-ico layui-layer-close layui-layer-close1']").click
          sleep 3
        end
        click_button 'OK'

        find("a[title='Add']", :text => /Add/).click

        within_visible_frame do
          sleep 3
          # click_button 'plupload-images'
          execution_data.item_title = 'Automation Item'
          find("input[id='c-title']").set execution_data.item_title
          find("input[value='All']").set true
          find("input[id='c-images']").set thumbnail_path
          find("input[id='c-document']").set downloadable_pdf_path
          sleep 3
        end
        click_button 'OK'
      end
      find("a[class='layui-layer-ico layui-layer-close layui-layer-close1']").click
      sleep 3
    end
  end

  def delete_item(section_name)
    within_visible_frame do
      find(:xpath, "//td[contains(., '#{section_name}')]/../td/a[contains(., 'Add Items')]").click
      within_visible_frame do
        within_visible_frame do
          within_visible_frame do
            find(:xpath, "//td[contains(., '#{execution_data.item_title}')]/../td[contains(@class, 'bs-checkbox ')]/input").set true
          end
          find("a[title='Delete']").click
          sleep 1
          find("button[class='layui-layer-confirm']").click
        end
      end
    end
  end



end
