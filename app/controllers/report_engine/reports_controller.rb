module ReportEngine
  class ReportsController < ApplicationController

    def index
      @datas = User.charts
    end

  end
end