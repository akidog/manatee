module JavascriptRenderer
  class Config
    def method_missing(method, *args, &block)
      str_method = method.to_s
      if str_method[-1] == '=' && JavascriptRenderer.methods(false).include?(str_method[0..-2].to_sym)
        if block_given?
          JavascriptRenderer.default_config str_method[0..-2].to_sym, &block
        else
          JavascriptRenderer.instance_variable_set :"@#{str_method[0..-2]}", args.first
        end
      else
        super method, *args, &block
      end
    end
  end
end
