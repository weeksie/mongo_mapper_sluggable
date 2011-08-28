module MongoMapper
  module Sluggable
    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
      
      base.slug_keys
      base.slug_callbacks
    end
    
    module ClassMethods
      def slug_callbacks
        before_validation :parameterize_slug
        validate :slug_conflict_check      
      end
      def slug_keys
        key :slug, String, :index => true, :protected => true, :required => true
      end
      def allow_non_unique_slug
        @non_unique_slug = true
      end
      def allow_non_unique_slug?
        @non_unique_slug ||= false
      end
      def slugged_attr(attr_name)
        @slugged_attr = attr_name.to_sym
      end
      def slugged_attr_name
        @slugged_attr ||= :name
      end
    end
    
    module InstanceMethods
        
      def to_param
        slug
      end
      
      protected
      
      def parameterize_slug
        attr = send self.class.slugged_attr_name
        return if attr.nil? # other validations will catch this
        if slug.nil?
          self.slug = attr.parameterize.to_s
        else
          self.slug = slug.parameterize.to_s
        end
      end
      
      def slug_conflict_check
        slug_count = self.class.count(:slug => self.slug, :id.ne => self.id)
        if slug_count > 0
          if self.class.allow_non_unique_slug?
            self.slug << "-#{self.id}"
          else
            errors.add(self.class.slugged_attr_name, "has already been taken")
          end
        end
      end
      
    end
  end
end
