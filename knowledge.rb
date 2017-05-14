require 'byebug'

puts 'Hello!'

class Object

  # def after_method(name, &block)
  #   original_method = instance_method(name)
  #   define_method(name) do |*args|
  #     original_method.bind(self).call(*args)
  #     block.call(*args)
  #   end
  # end

  def attribute(name, &block)
    puts name

    if name.instance_of?(Hash)
      inst_var = '@' + name.keys[0]
      method_name = name.keys[0]
      # define_method(:after_method(:initialize) do |@defaults|
      #   puts @defaults
      # end
      define_method(:initialize) do |*args|
        super(*args)
        instance_variable_set(inst_var, name.values[0])
      end
    elsif block_given?
      inst_var = '@' + name
      method_name = name
      define_method(:initialize) do |*args|
        super(*args)
        value = instance_eval(&block)
        instance_variable_set(inst_var, value)
      end
    else
      inst_var = '@' + name
      method_name = name
    end

    class_eval { attr_accessor method_name }
    # define_method(method_name.to_sym) { instance_variable_get(inst_var) }
    # define_method((method_name + '=').to_sym) { |arg| instance_variable_set(inst_var, arg) }
    define_method((method_name + '?').to_sym) { instance_variable_get(inst_var) ? true : false }

  end
end

puts 'Bye!'
