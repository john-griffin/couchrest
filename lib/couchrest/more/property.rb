module CouchRest

  # Basic attribute support for adding getter/setter + validation
  class Property
    attr_reader :name, :type, :read_only, :alias, :default, :casted, :init_method, :options

    # attribute to define
    def initialize(name, type = nil, options = {})
      @name = name.to_s
      parse_type(type)
      parse_options(options)
      self
    end

    private

      def parse_type(type)
        if type.nil?
          @type = 'String'
        elsif type.is_a?(Array) && type.empty?
          @type = ['Object']
        else
          @type = type.is_a?(Array) ? [type.first.to_s] : type.to_s
        end
      end

      def parse_options(options)
        return if options.empty?
        @validation_format  = options.delete(:format)     if options[:format]
        @read_only          = options.delete(:read_only)  if options[:read_only]
        @alias              = options.delete(:alias)      if options[:alias]
        @default            = options.delete(:default)    unless options[:default].nil?
        @casted             = options[:casted] ? true : false
        @init_method        = options[:init_method] ? options.delete(:init_method) : 'new'
        @options            = options
      end

  end
end

class CastedArray < Array
  attr_accessor :casted_by
  
  def << obj
    obj.casted_by = self.casted_by if obj.respond_to?(:casted_by)
    super(obj)
  end
  
  def push(obj)
    obj.casted_by = self.casted_by if obj.respond_to?(:casted_by)
    super(obj)
  end
  
  def []= index, obj
    obj.casted_by = self.casted_by if obj.respond_to?(:casted_by)
    super(index, obj)
  end
end
