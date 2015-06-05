class MethodObserver

  VERSION = '0.0.1'

  @before = ->(klass, target, method, *args, &block) {}
  @after  = ->(klass, target, method, *args, &block) {}
  @around = ->(klass, target, method, *args, &block) { block.call }

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

      observed_method = "__#{method}_observed__"
      klass.send :alias_method, observed_method, method
      klass.send :private, observed_method
      
      klass.send(:define_method, method) do |*args, &block|
        observe_before.call klass, :instance, method, args
        result = observe_around.call klass, :instance, method, args do
          send observed_method, *args, &block
        end
        observe_after.call klass, :instance, method, args
        result
      end
    end

    def observe_class_method(klass, method)
      observe_before = @before
      observe_after  = @after
      observe_around = @around

      observed_method = "__#{method}_observed__"
      klass.singleton_class.send :alias_method, observed_method, method
      klass.singleton_class.send :private, :new
      
      klass.send(:define_singleton_method, method) do |*args, &block|
        observe_before.call klass, :class, method, args
        result = observe_around.call klass, :class, method, args do
          send observed_method, *args, &block
        end
        observe_after.call klass, :class, method, args
        result
      end
    end

  end
end