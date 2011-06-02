module ReportEngine
  class Engine < Rails::Engine
    initializer "report_engine" do
      require 'lazy_high_charts_patch/layout_helper'
      ActiveRecord::Base.send(:extend, ReportEngine::Base)
    end

    rake_tasks do
    end

    generators do
    end

    config.to_prepare do
    end
  end
end