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
        base.send(:extend, self)
        base.send(:include, ::Validatable)
        
        unless base.to_s.downcase == "spec::example::examplegroup::subclass_1"
          base.class_eval <<-EOS, __FILE__, __LINE__
            def initialize
              self.id = self.next_id_for_klass(self.class)
            end
          EOS
        end
        
        rsrc_sym = base.to_s.make_key
        @@map ||= AssociationMap.new
        @@store ||= DataStore.new
        unless @@store.resources.include? rsrc_sym
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
    def field(name, klass, *args)
      klass_sym = self.to_s.make_key
      unless @@fields[klass_sym]
        @@fields[klass_sym] = [{:name => name, :klass => klass}]
      else
        @@fields[klass_sym] << {:name => name, :klass => klass}
      end
      
      name = name.to_s
      
      self.class_eval <<-EOS, __FILE__, __LINE__
        def #{name}
          @#{name}
        end
        
        def #{name}=(value)
          @#{name} = value
        end
      EOS
    end
    
    def id=(value)
      @id = value
    end
    
    def id
      @id
    end
    
    # hmmmm, this is a tricky one...
    def validates_uniqueness_of(field)s
    end
    
    def before_save(meth, *args)
    end
    
    def before_destroy(meth, *args) 
    end
    
    def before_create(meth, *args)
    end
    
    def after_save(meth, *args)
    end
    
    def after_create(meth, *args)
    end
    
    def after_destroy(meth, *args)
    end
    
    def has_many(resource, *args)
    end
    
    def has_one(resource, *args)
    end
    
    def belongs_to(resource, *args)
    end
    
    def has_and_belongs_to_many(resource, *args)
    end
    
    def save
      return false unless self.valid? && self.fields_are_valid?
      sym = DataStore.determine_save_method(self, @@store)
      self.class.send(sym, self)
    end
    
    def fields_are_valid?
      klass_sym = self.class.to_s.make_key
      @@fields[klass_sym].each do |field|
        unless self.send(field[:name]).class == field[:klass] || self.send(field[:name]) == nil
          return false 
        end
      end
      true
    end
    
    # Returns the first object matching +conditions+, or the first object
    # if no conditions are specified
    # === Parameters
    # +conditions+::
    #   A string representing one or more Ruby expressions
    # === Example
    # <tt>Author.first("name ~= /Nick/i && email.include?('gmail.com')")</tt>
    def first(conditions = nil)
      objs = []
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
    #   A string representing one or more Ruby expressions
    # === Example
    # <tt>Author.all("created_at < DateTime.now")</tt>
    def all(conditions = nil)
      objs = []
      unless conditions
        @@store.resources[self.to_s.make_key].each do |o|
          objs << o[1]
        end
      else
        objs = find(conditions, self.to_s.make_key)
      end
      objs
    end
    
    # Synonymous for get
    # === Parameters
    # +id+:: id of the object to retrieve
    def [](id)
      raise "Expected Fixnum, got #{id.class} for #{self.to_s}[]" \
        unless id.class == Fixnum
      get(id)
    end
    
    def fields
      @@fields
    end
    
    def delete(id)
    end
    
    # Allow for retrieval of an object in the @@store by id
    # === Parameters
    # +id+:: id of the object to retrieve 
    def get(id)
      @@store.resources[self.to_s.make_key].each do |o|
        return o[1] if o[0] == id
      end
      false
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

    private
    def post(obj)
      obj.created_at = DateTime.now if field_declared?(:created_at,obj.class)
      obj.updated_at = DateTime.now if field_declared?(:updated_at,obj.class)
      DataStore.write_yaml(obj)
      @@store.resources[obj.class.to_s.make_key] << [obj.id, obj]
      true
    end

    def put(id, obj)
    end
    
    # Find an object according to +conditions+ provided
    # === Parameters
    # +conditions+:: A plain string representation of a set of conditions
    # +key+:: 
    #   A symbol representing the class of objects to look for in +@@store+
    def find(conditions, key) #:doc:
      objs = []
      parsed_conditions = parse_conditions(conditions)
      @@store.resources[key].each do |o|
        objs << o[1] if matches_conditions?(o[1], parsed_conditions)
      end
      objs
    end
    
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
            tf_ary << obj.instance_eval(cond)
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
    
    # Accepts +conditions+ like 
    # "name.include?('nick') && email == 'nick@bzzybee.com"
    # and turns them into an +ary+ of expressions and their conditionals
    # === Parameters
    # +conditions+:: The plain string conditions
    def parse_conditions(conditions) #:doc:
      ary = []
      # Facets breaks for some reason on single condition expressions
      # e.g. "name == 'Nick DeMonner'"
      # but not on multiple ones like
      # "name == 'Nick DeMonner' && blah.include?('blah')"
      begin
        expr = conditions.split(/\s+&{2}|\|{2}\s+/)
      rescue
        expr = [conditions]
      end
      op = conditions.scan(/&{2}|\|{2}/)
      expr.each_with_index do |e,i|
        ary << e.strip
        ary << op[i] if op[i]
      end
      # convert each expr into an obj.meth(arg) format
      # so that name == 'nick' becomes name.==('nick')
      ary.each_with_index do |e,i|
        if i % 2 == 0 && e.split.size != 1
          expr_ary = e.split
          expr_ary[0] = expr_ary[0] + "."
          expr_ary[1] = expr_ary[1] + "("
          if expr_ary.size % 2 == 0
            expr_ary[expr_ary.size-1] = " " + expr_ary[expr_ary.size-1] + ")"
          else
            expr_ary[expr_ary.size-1] = expr_ary[expr_ary.size-1] + ")"
          end
          ary[i] = expr_ary.join
        end
      end
      ary
    end
  end # Resource
  
end # Stone