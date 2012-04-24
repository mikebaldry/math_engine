require File.expand_path(File.join(File.dirname(__FILE__), "../helpers/" ,  'views_helpers'))

module MathEngine
  class Railtie < Rails::Railtie
    initializer "MathEngine.view_helpers" do
      ActionView::Base.send :include, ViewsHelpers
    end
  end
end
