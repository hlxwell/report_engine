module ReportEngine
  Rails.application.routes.draw do
    scope 'admin/report', :module => :report_engine do
      match '/', :controller => 'reports', :action => 'index'
    end
  end
end