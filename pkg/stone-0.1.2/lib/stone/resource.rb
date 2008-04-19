module Stone
  
  # Adds the ability to persist any class it is included in
  # === Example
  #
  # class Post
  #   include Stone::Resource
  #   
  #   field :body, String
  # end
  #
  module Resource
    
    class << self
      def included(base)
        rsrc_sym = base.to_s.make_key
        
        @@callbacks ||= Callbacks.new
        @@callbacks.register_klass(base)
        
        @@store ||= DataStore.new
        
        base.send(:extend, self)
        base.send(:include, ::Validatable)
        
        # rspec breaks if its classes have their contructor overwritten
        unless base.to_s.downcase =~ /(spec::example::examplegroup::subclass_\d|blah)/
          # allow object to be created with a hash of attributes...
          # [] allows for obj[attribute] retrieval
          # to_s allows for stupid Rails to work
          base.class_eval <<-EOS, __FILE__, __LINE__
            def initialize(hash = nil)
              self.id = self.next_id_for_klass(self.class)
              unless hash.blank?
                hash.each_key do |k|
                  if hash[k].is_a? Hash
                    hash[k].each do |k,v|
                      self.send(k.to_s+"=",v)
                    end
                  else
                    self.send(k.to_s+"=", hash[k])
                  end
                end
              end
              @@fields[self.class.to_s.make_key].each do |f|
                instance_variable_set("@"+f[:name].to_s,[]) if f[:klass] == Array
              end
            end
            
            def to_s
              id
            end
            
            def [](sym)
              self.send(sym)
            end
          EOS
        end
        
        unless @@store.resources.include?(rsrc_sym)
          @@store.resources[rsrc_sym] = DataStore.load_data(rsrc_sym)
        end
      end
    end # self
    
    @@fields = {}
    
    # Adds a given field to @@fields and inserts an accessor for that
    # field into klass
    # === Parameters
    # +name+<String>::
    #    
    def field(name, klass, arg = nil)
      if arg && arg[:unique] == true
        unique = true
      else
        unique = false
      end
      klass_sym = self.to_s.make_key
      unless @@fields[klass_sym]
        @@fields[klass_sym] = [{:name => name, 
                                :klass => klass, 
                                :unique => unique}]
      else
        @@fields[klass_sym] << {:name => name, 
                                :klass => klass, 
                                :unique => unique}
      end
      name = name.to_s
      # add accessor for given field
      unless klass == Array
        self.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            @#{name}
          end
        
          def #{name}=(value)
            @#{name} = value
          end
        EOS
      else
        self.class_eval <<-EOS, __FILE__, __LINE__          
          def #{name}
            @#{name}
          end
        EOS
      end
    end # field
    
    def id=(value)
      @id = value
    end
    
    def id
      @id
    end
    
    # Registers the given method with the current instance of Callbacks. Upon
    # activation (in this case, right before Resource.save is executed), the
    # +meth+ given is called against the object being, in this case, saved.
    #
    # Note that there is no before_validation callback, because Stone
    # before_save triggers before validations occur anyway
    # === Parameters
    # +meth+:: The method to be registered
    def before_save(meth)
      @@callbacks.register(:before_save, meth, self)
    end
    
    # See before_save
    def after_save(meth)
      @@callbacks.register(:after_save, meth, self)
    end
    
    
    # See before_save
    def before_create(meth)
      @@callbacks.register(:before_create, meth, self)
    end
    
    # See before_save
    def after_create(meth)
      @@callbacks.register(:after_create, meth, self)
    end
    
    # See before_save
    def before_delete(meth) 
      @@callbacks.register(:before_delete, meth, self)
    end
    
    # See before_save
    def after_delete(meth)
      @@callbacks.register(:after_delete, meth, self)
    end
    
    # Registers a one-to-many relationship for +resource+
    # === Parameters
    # +resource+::
    #   the resource of which this class has many
    def has_many(resource, *args)
      self.class_eval <<-EOS, __FILE__, __LINE__
        def #{resource.to_s}
          #{resource.to_s.singularize.titlecase}.all("#{self.to_s.downcase}_id".to_sym.equals => self.id)
        end
      EOS
    end
    
    # Registers a one-to-one relationship for +resource+
    # === Parameters
    # +resource+::
    #   the resource of which this class has one
    def has_one(resource, *args)
      field "#{resource.to_s}_id".to_sym, Fixnum
    end
    
    # Registers a belongs_to association for +resource+
    # === Parameters
    # +resource+ :: The resource to which this class belongs
    def belongs_to(resource, *args)
      field "#{resource.to_s}_id".to_sym, Fixnum
      self.class_eval <<-EOS, __FILE__, __LINE__
        def #{resource.to_s} 
          #{resource.to_s.titlecase}[self.#{resource.to_s}_id]
        end
      EOS
    end
    
    # Registers a many-to-many association using an array of +resource+
    # ids.
    # === Parameters
    # +resource+::
    #   The resource of which this class belongs to and has many
    def has_and_belongs_to_many(resource, *args)
      field resource, Array
    end
    
    alias_method :habtm, :has_and_belongs_to_many
    
    # Returns the first object matching +conditions+, or the first object
    # if no conditions are specified
    # === Parameters
    # +conditions+::
    #   A hash representing one or more Ruby expressions
    def first(conditions = nil)
      unless conditions
        return @@store.resources[self.to_s.make_key].first[1]
      else
        return find(conditions, self.to_s.make_key)[0]
      end
    end
    
    # Returns all objects matching +conditions+, or all objects if no
    # conditions are specified
    # === Parameters
    # +conditions+::
    #   A hash representing one or more Ruby expressions
    def all(conditions = nil)
      objs = []
      # check for order conditions, make conditions nil if an order condition
      # is the only one passed to Resource.all
      if conditions && conditions[:order]
        order = conditions[:order].to_a.flatten
        conditions.delete(:order)
        conditions = nil if conditions.empty?
      end
      # Don't bother getting into crazy object searches if there are no
      # conditions -- just grab the objects directly out of the current 
      # store
      unless conditions
        @@store.resources[self.to_s.make_key].each do |o|
          objs << o[1]
        end
      else
        objs = find(conditions, self.to_s.make_key)
      end
      if order
        raise "Order should be passed with :asc or :desc, got #{order[1].inspect}" \
          unless [:asc,:desc].include? order[1]
        # FIXME: something about this breaks under certain conditions 
        # that I can't find yet
        begin
          objs.sort! {|x,y| x.send(order[0]) <=> y.send(order[0])}
        rescue
        end
        objs.reverse! if order[1] == :desc
      end
      objs
    end
    
    # Synonymous for get
    # === Parameters
    # +id+:: id of the object to retrieve
    def [](id)
      raise "Expected Fixnum, got #{id.class} for #{self.to_s}[]" \
        unless id.class == Fixnum || id.to_i
      get(id)
    end
    
    def fields
      @@fields
    end
    
    # Deletes the object with +id+ from the current DataStore instance and
    # its corresponding yaml file
    def delete(id)
      fire(:before_delete)
      DataStore.delete(id, self.to_s.downcase.pluralize)
      @@store.resources[self.to_s.make_key].each_with_index do |o,i|
        @@store.resources[self.to_s.make_key].delete_at(i) if o[0] == id
      end
      fire(:after_delete)
      true
    end
    
    # Allow for retrieval of an object in the current DataStore instance by id
    # === Parameters
    # +id+:: id of the object to retrieve 
    def get(id)
      id = id.to_i
      raise "Expected Fixnum, got #{id.class} for #{self.to_s}.get" \
        unless id.class == Fixnum
      @@store.resources[self.to_s.make_key].each do |o|
        return o[1] if o[0] == id
      end
      nil
    end
    
    # Puts the attribute changes in +hash+
    # === Parameters
    # +hash+:: the attributes to change
    def update_attributes(hash)
      hash.each_key do |k|
        if hash[k].is_a? Hash
          hash[k].each do |k,v|
            self.send(k.to_s+"=",v)
          end
        else
          self.send(k.to_s+"=", hash[k])
        end
      end
      self.save
    end
    
    # Determine the next id number to use based on the last stored object's id
    # of class +klass+
    # === Parameters
    # +klass+:: The class of the object to be saved
    def next_id_for_klass(klass)
      sym = klass.to_s.make_key
      if @@store.resources.has_key?(sym) && !@@store.resources[sym].blank?
        return @@store.resources[sym].last[0] + 1
      else
        return 1
      end
    end
    
    # Save an object to the current DataStore instance.
    def save
      return false unless self.fields_are_valid?
      fire(:before_save)
      return false unless self.valid?
      sym = DataStore.determine_save_method(self, @@store)
      self.class.send(sym, self)
      fire(:after_save)
    end
    
    # Determines whether the field classes of a given object match the field
    # class declarations
    def fields_are_valid?
      klass_sym = self.class.to_s.make_key
      @@fields[klass_sym].each do |field|
        unless self.send(field[:name]).class == field[:klass] || self.send(field[:name]) == nil || self.already_exists?
          return false 
        end
        if field[:unique] == true
          return false if self.class.first(field[:name] => self.send(field[:name])) && !self.already_exists?
        end
      end
      true
    end
    
    # Needed for Rails to work
    def new_record?
      !already_exists?
    end
    
    # Finds out if the object is already in the current DataStore instance
    def already_exists?
      DataStore.determine_save_method(self, @@store) == :put
    end
    
    private
    
    # Fires the given callback in the current instance of Callbacks
    # === Parameters
    # +cb_sym+:: The symbol for the callback (e.g. :before_save)
    def fire(cb_sym)
      @@callbacks.fire(cb_sym, self)
      true
    end
    
    # Creates a yaml file for +obj+ and adds +obj+ to the current DataStore
    # instance
    # === Parameters
    # +obj+:: The object to be saved
    def post(obj)
      fire(:before_create)
      obj.created_at = DateTime.now if field_declared?(:created_at,obj.class)
      obj.updated_at = DateTime.now if field_declared?(:updated_at,obj.class)
      DataStore.write_yaml(obj)
      @@store.resources[obj.class.to_s.make_key] << [obj.id, obj]
      fire(:after_create)
    end
    
    # Updates the yaml file for +obj+ and overwrites the old object in the
    # the current DataStore instance
    # === Parameters
    # 
    def put(obj)
      obj.updated_at = DateTime.now if field_declared?(:updated_at,obj.class)
      DataStore.write_yaml(obj)
      @@store.resources[obj.class.to_s.make_key].each do |o|
        o[1] = obj if o[0] == obj.id
      end
      true
    end
    
    # Find an object according to +conditions+ provided
    # === Parameters
    # +conditions+:: A plain string representation of a set of conditions
    # +key+:: 
    #   A symbol representing the class of objects to look for in the current
    #   DataStore instance
    def find(conditions, key) #:doc:
      objs = []
    
      if conditions.is_a? Hash
        unless conditions.to_a.flatten.map {|e| e.is_a? Query}.include?(true)
          conds = conditions.to_a.flatten
          @@store.resources[key].each do |o|
            objs << o[1] if o[1].send(conds[0]) == conds[1]
          end
        else
          parsed_conditions = parse_conditions(conditions)
          @@store.resources[key].each do |o|
            objs << o[1] if matches_conditions?(o[1], parsed_conditions)
          end
        end
      else
        raise "Resource.find expects a Hash, got a #{conditions.class}"
      end
      objs
    end
    
    # Checks the list of fields for a given +klass+ to see if +field+
    # is included
    # === Parameters
    # +field+:: The field to look for
    # +klass+:: The class to look in 
    def field_declared?(field,klass)
      @@fields[klass.to_s.make_key].each do |f|
        return true if f[:name] == field
      end
      false
    end
    
    # Executes and evaluates the expressions in +conds+ against 
    # the +obj+ provided, and then evaluates those results against
    # the conditionals ("&&") in +conds+
    # === Parameters
    # +obj+:: The object to compare against
    # +conds+:: 
    #   A set of expressions (name == 'nick') and their conditionals
    #   ('&&')
    def matches_conditions?(obj, conds) #:doc:
      tf_ary = []
      conds.each_with_index do |cond,i|
        # build an array like [true, "&&", false, "&&", true]
        if i % 2 == 0
          begin
            bool = obj.instance_eval(cond)
            bool = false unless bool
            bool = true if bool.class == Fixnum
            tf_ary << bool
          rescue
            tf_ary << false
          end
        else
          tf_ary << cond
        end
      end
      # evaluate the true/false array
      eval(tf_ary.join)
    end
    
    # Turns conditions into a set of expressions that can be evaluated
    def parse_conditions(hash)
      conds = []
      hash.each do |k,v|
        conds << k.expression_for(v)
        conds << "&&"
      end
      conds.pop
      conds
    end
  end # Resource
  
end # Stone