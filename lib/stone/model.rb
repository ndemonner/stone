module Stone
  module Model    
    def self.included(base)
      base.extend Actions
      base.extend Attributes
      base.extend Relationships
      base.extend Validations
      base.extend Callbacks
    end
  end
end