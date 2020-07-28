require 'mysql2'

class DBQueries
  def initialize
    db_info = Config.env_config[:unsw_militech_top_database]
    @client = Mysql2::Client.new(:host => db_info['host'], :username => db_info['username'], :password => db_info['password'], :database => db_info['database'])
  end

  def delete_test_user(email)
    results = @client.query("select * from un_member where email='#{email}'")
    @client.query("delete from un_member where email='#{email}' and id='#{results.first['id']}'")
  end
end

