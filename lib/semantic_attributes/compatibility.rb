module SemanticAttributes #:nodoc:
  # Integrates other common plugins and core Rails methods with SemanticAttributes
  # This module is not automatically mixed-in for two reasons:
  # 1) it may not be desired
  # 2) it needs to happen *after* all other plugins have been initialized
  module Compatibility
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def self.included(base)
        # enum-column-for-rails
        # http://rubyforge.org/projects/enum-column/
        columns.collect {|c| c.type == :enum}.each do |enum_column|
          self.semantic_attributes[attr].add 'enumeration', :options => enum_column.values
        end
      end

      # file_column
      # http://www.kanthak.net/opensource/file_column/
      def file_column(attr, *args)
        self.semantic_attributes[attr].add 'file'
        super
      end

      # acts_as_attachment
      # http://technoweenie.stikipad.com/plugins/show/Acts+as+Attachment
      def acts_as_attachment(*args)
        self.semantic_attributes[:uploaded_data].add 'file'
        super
      end

      # attachment_fu
      # http://weblog.techno-weenie.net/2007/2/25/attachment_fu-tutorial
      def has_attachment
        self.semantic_attributes[:uploaded_data].add 'file'
        super
      end
    end
  end
end