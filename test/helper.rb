require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'simplificator-mongomapper-tree'

class Test::Unit::TestCase
end
require 'mongo_mapper'
# TODO: use database with transactions...

MongoMapper.database = 'simplificator-mm-tree-test-will-drop-ot'
class TreeNode
  include MongoMapper::Document
  include MongoMapper::Tree

  key :name, String

  key :path, String
  key :depth, Integer

  # both needed
  key :parent_id, Mongo::ObjectID
  belongs_to :parent, :class_name => 'TreeNode'

  many :children, :class_name => 'TreeNode', :foreign_key => :parent_id
end
