module ReportEngine
  module Base
    def chart options
      parse_options options
    end

    # will get charts hash data
    #
    def charts
      return {} if @@report_title.blank?
      {:test => "test"}
    end

    protected

    def parse_options options
      @@report_title     = options.delete(:title)
      @@report_type      = options.delete(:type)
      @@report_x_columns = options.delete(:x)
      @@report_y_columns = options.delete(:y)

      if @@report_x_columns.blank? and @@report_y_columns.blank?
        @@report_columns   = options.delete(:columns)
      elsif options[:columns].present? and Rails.env != 'production'
        caller[0].match(/`([^']*)'/)
        puts "\e[31mYou have defined :x and :y nodes for options of #{self.name}.#{$1} so the :columns node won't be loaded.\e[0m"
      end
    end
  end
end