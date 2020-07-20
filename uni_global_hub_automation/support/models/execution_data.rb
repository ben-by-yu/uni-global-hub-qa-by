class ExecutionData
  attr_accessor :client,
                :flag

  def initialize
    @user_portal = Hashie::Mash.new
  end
end
