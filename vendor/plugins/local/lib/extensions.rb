# Extends the module object with module and instance accessors for class attributes, 
# just like the native attr* accessors for instance attributes.
class Module # :nodoc:
  def mattr_reader(*syms)
    syms.each do |sym|
      next if sym.is_a?(Hash)
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end
        
        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
  end
  
  def mattr_writer(*syms)
    options = syms.last.is_a?(Hash) ? syms.pop : {}
    syms.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end
        
        def self.#{sym}=(obj)
          @@#{sym} = obj
        end
        
        #{"
        def #{sym}=(obj)
          @@#{sym} = obj
        end
        " unless options[:instance_writer] == false }
      EOS
    end
  end
  
  def mattr_accessor(*syms)
    mattr_reader(*syms)
    mattr_writer(*syms)
  end
end

class Hash #:nodoc:
      # Allows for reverse merging where its the keys in the calling hash that wins over those in the <tt>other_hash</tt>.
      # This is particularly useful for initializing an incoming option hash with default values:
      #
      #   def setup(options = {})
      #     options.reverse_merge! :size => 25, :velocity => 10
      #   end
      #
      # The default :size and :velocity is only set if the +options+ passed in doesn't already have those keys set.

    def reverse_merge(other_hash)
      other_hash.merge(self)
    end

    def reverse_merge!(other_hash)
      replace(reverse_merge(other_hash))
    end
        
    def symbolize_keys
      inject({}) do |options, (key, value)|
        options[key.to_sym] = value
        options
      end
    end

    # Destructively convert all keys to symbols.
    def symbolize_keys!
      keys.each do |key|
        unless key.is_a?(Symbol)
          self[key.to_sym] = self[key]
          delete(key)
        end
      end
      self
    end
end

class String #:nodoc:
  # Does the string start with the specified +prefix+?
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end

module Kernel#:nodoc:
  def singleton_class
    class << self; self; end
  end
end