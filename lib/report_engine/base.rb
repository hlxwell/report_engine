module ReportEngine
  module Base
    def chart options
      parse_options options
    end

    # will get charts hash data
    #
    def charts
      @@charts
    end

    protected

    def parse_options options
      chart_option = {
        :title     => options.delete(:title),
        :type      => options.delete(:type),
        :x_columns => options.delete(:x),
        :y_columns => options.delete(:y),
        :columns => options.delete(:columns)
      }

      chart_option.delete(:x_columns) if chart_option[:x_columns].blank?
      chart_option.delete(:y_columns) if chart_option[:y_columns].blank?

      # alert if set both columns and x_columns, y_columns
      if Rails.env != 'production' and
        chart_option[:columns].present? and
        chart_option[:x_columns].present? and
        chart_option[:y_columns].present?

        puts "\e[31mYou have defined :x and :y nodes for options at #{caller[0]} so the :columns node won't be loaded.\e[0m"
      end

      @@charts ||= []
      @@charts << chart_option
    end
  end
end