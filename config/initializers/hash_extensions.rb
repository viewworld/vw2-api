module HashExtensions
  refine Hash do
    def report_id
      keys.first.to_i
    end

    def report_value
      values.first
    end

    def report_value_type
      values.first.class.name.underscore.to_sym
    end

    def form_media?
      self['type'] == 'media'
    end
  end
end
