class PageLoader
  def initialize
    @pages ={}
  end

  def page(world, page_name)
    @pages[page_name] ||= load_page(world, page_name)
  end

  def load_page(world, page_name)
    page_name_class = page_name.to_s.camelize.constantize
    defined?(page_name_class) ? page_name_class.new(world) : nil
  end
end