require_relative '../lib/method_observer'

class Dummy
  def foo
    puts 'Running foo'
    bar
  end

  def bar
    puts 'Running bar'
  end
end

class Profiler

  def initialize
    @nesting_level = 0
  end

  def track(klass, target, method, *args, &block)
    @nesting_level += 1
    nesting = '  ' * (@nesting_level - 1)
    puts "#{nesting}Before: #{klass}#{target == :class ? '.' : '#'}#{method}"
    result = block.call
    puts "#{nesting}After: #{klass}#{target == :class ? '.' : '#'}#{method}"
    @nesting_level -= 1
    result
  end

end


MethodObserver.configure do |config|
  profiler = Profiler.new

  config.around do |klass, target, method, *args, &block|
    profiler.track klass, target, method, *args, &block
  end

  config.observe Dummy, instance: [:foo, :bar]
end

dummy = Dummy.new
dummy.foo