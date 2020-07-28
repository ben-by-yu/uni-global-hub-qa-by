require 'yaml'
require 'active_support/core_ext/hash'

class Config

  def initialize(file)
    @file = file
  end

  def load
    YAML::load_file(@file).with_indifferent_access
  end

  def self.env_config
    @@env_config ||= load_env_config
  end

  def self.user_config
    @@user_config ||= load_user_config
  end

  def self.test_env
    @@test_env ||= (ENV['TEST_ENV'] || user_config[:test_env] || 'test').downcase
  end

  def self.workflow_config
    @@workflow_config ||= load_workflow_config
  end

  private
  def self.load_user_config
    # username = Etc.getlogin
    user_config_file = File.join(__dir__, '..', 'config', 'profiles', "test.yml")
    File.exists?(user_config_file) ? Config.new(user_config_file).load : {}
  end

  def self.load_env_config
    env_config = Config.new(File.join(__dir__, '..', 'config', 'env', "#{test_env}.yml")).load
    env_config
  end

end
