module MongoMapper
  module Tree
    PATH_SEPARATOR = '-'
    module ClassMethods
    end

    module InstanceMethods
      # Root node of the tree
       def root
         self.class.first(:id => root_id)
       end

       def ancestor_of?(node)
         node.path.start_with?(self.path)
       end

       def descendant_of?(node)
         self.path.start_with?(node.path)
       end

       # all children
       def descendants
         self.class.all(:path => descendants_regexp, :order => 'path')
       end

       # all brothers and sisters (nodes with same parent) but self
       def siblings
         self.class.all(:id => {'$ne' => self.id}, :path => siblings_path_regexp, :depth => self.depth, :order => 'path')
       end

       # all brothers and sisters including self
       def self_and_siblings
         self.class.all(:path => siblings_path_regexp, :depth => self.depth, :order => 'path')
       end

       def ancestors
         self.class.all(:path => {'$in' => ancestor_paths}, :order => 'path desc')
       end

       def self_and_ancestors
         self.class.all(:path => {'$in' => ancestor_paths << self.path}, :order => 'path desc')
       end

       private
       def set_path
         if self.parent_id
           self.path = "#{self.parent.path}#{PATH_SEPARATOR}#{self.id}"
         else
           self.path = "#{self.id}"
         end
       end

       # depth of the tree is stored in an attribute even though
       # it could be calculated since
       # depth is needed in queries
       def set_depth
         self.depth = self.path.count(PATH_SEPARATOR)
       end

       def root_id
         self.path.split(PATH_SEPARATOR).first
       end

       # builds the paths of all ancestors, root node first
       def ancestor_paths
         parent_path.split(PATH_SEPARATOR).inject([]) do |memo, item|
           memo << (memo.length > 0 ? "#{memo.last}#{PATH_SEPARATOR}#{item}" : item)
           memo
         end
        end

       # helper method to get the parent path without loading parent
       def parent_path
         self.path.split(PATH_SEPARATOR)[0...-1].join(PATH_SEPARATOR)
       end
       def siblings_path_regexp
         /#{parent_path}.*/
       end

       def descendants_regexp()
         /#{self.path}#{PATH_SEPARATOR}.*/
       end

       def ancestors_path_regexp
         /#{root_id}.*/
       end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods

      receiver.instance_eval do
        # only after create... moving of nodes not allowed (yet)
        before_create :set_path
        before_create :set_depth
      end
    end
  end
end