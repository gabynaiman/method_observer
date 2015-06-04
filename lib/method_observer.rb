class MethodObserver

  VERSION = '0.0.1'

  class << self

    alias_method :configure, :tap

    def before(&block)
      @before = block
    end
    
    def after(&block)
      @after = block
    end
    
    def around(&block)
      @around = block
    end

    def observe(klass, options)
      options.fetch(:instance, []).each do |method|
        observe_instance_method klass, method
      end

      options.fetch(:class, []).each do |method|
        observe_class_method klass, method
      end
    end

    private

    def observe_instance_method(klass, method)
      observe_before = @before
      observe_after  = @after
      observe_around = @around

      new_method = "__#{method}_observed__"
      klass.send :alias_method, new_method, method
      
      klass.send(:define_method, method) do |*args, &block|
        observe_before.call klass, :instance, method, args
        observe_around.call klass, :instance, method, args do
          send new_method, *args, &block
        end
        observe_after.call klass, :instance, method, args
      end
    end

    def observe_class_method(klass, method)
      observe_before = @before
      observe_after  = @after
      observe_around = @around

      new_method = "__#{method}_observed__"
      klass.singleton_class.send :alias_method, new_method, method
      
      klass.send(:define_singleton_method, method) do |*args, &block|
        observe_before.call klass, :class, method, args
        observe_around.call klass, :class, method, args do
          send new_method, *args, &block
        end
        observe_after.call klass, :class, method, args
      end
    end

  end
end