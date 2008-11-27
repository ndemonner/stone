module Stone
  class Callbacks < Hash
    
    CALLBACKS = [
      :before_save,
      :after_save,
      :before_create,
      :after_create,
      :before_destroy,
      :after_destroy
      ]
    
    class << self
      
    end # self
    
    # Registers the +klass+ with the current instance of Callbacks in Resource
    # === Parameters
    # +klass+:: The class to be registered
    def register_klass(klass)
      self[klass.to_s.make_key] = {}
      CALLBACKS.each do |cb_sym|
        self[klass.to_s.make_key][cb_sym] = []
      end
    end
    
    # Adds a given +meth+ to the +cb_sym+ array in the current Callbacks 
    # hash based on +klass+
    # === Parameters
    # +cb_sym+:: where +meth+ will be added
    # +meth+:: method to be added
    # +klass+:: determines which +cb_sym+ array will be used
    def register(cb_sym, meth, klass)
      self[klass.to_s.make_key][cb_sym] << meth
    end
    
    # Sends any methods registered under +cb_sym+ to +obj+
    # === Parameters
    # +cb_sym+:: Used to retrieve the methods to send
    # +obj+:: The object to which the retrieved methods are sent
    def fire(cb_sym, obj)
      unless obj.model.make_key == :class
        self[obj.model.make_key][cb_sym].each do |meth|
          obj.send(meth) unless meth.blank?
        end
      end
      true
    end
  end # Callbacks
end # Stone