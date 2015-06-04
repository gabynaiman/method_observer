require_relative '../lib/method_observer'

class Dummy
  def self.foo
    puts 'Running foo'
  end

  def bar
    puts 'Running bar'
  end
end


MethodObserver.configure do |config|
  config.before do |klass, target, method, *args|
    puts "Before: #{klass}#{target == :class ? '.' : '#'}#{method}"
  end

  config.after do |klass, target, method, *args|
    puts "After: #{klass}#{target == :class ? '.' : '#'}#{method}"
    puts
  end

  config.around do |klass, target, method, *args, &block|
    puts "Around before: #{klass}#{target == :class ? '.' : '#'}#{method}"
    block.call
    puts "Around after: #{klass}#{target == :class ? '.' : '#'}#{method}"
  end
  
  config.observe Dummy, class: [:foo], instance: [:bar]
end

Dummy.foo
Dummy.name

p = Dummy.new
p.bar
p.to_s