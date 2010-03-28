require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'simplificator-mongomapper-tree'

class Test::Unit::TestCase
end
require 'mongo_mapper'

# TODO: howto do this?
MongoMapper.database = 'simplificator-mm-tree-test-will-drop-ot'
class TreeNode
  include MongoMapper::Document
  include MongoMapper::Tree
  # make sure this works nicely with the regexps used to look up children and so on
  PATH_SEPARATOR = '-'
  key :name, String
  key :path, String
  key :depth, Integer

  # both needed
  key :parent_id, Mongo::ObjectID
  belongs_to :parent, :class_name => 'TreeNode'

  many :children, :class_name => 'TreeNode', :foreign_key => :parent_id



end
