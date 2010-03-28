require 'helper'

class TreeTest < Test::Unit::TestCase

  context 'some nodes' do
    setup do
      TreeNode.delete_all
      @root = TreeNode.create(:name => 'root')
      @child_1 = TreeNode.create(:name => 'child 1', :parent => @root)
      @child_2 = TreeNode.create(:name => 'child 2', :parent => @root)
      @child_3 = TreeNode.create(:name => 'child 3', :parent => @root)

      @child_1_1 = TreeNode.create(:name => 'child 1 1', :parent => @child_1)
      @child_1_2 = TreeNode.create(:name => 'child 1 2', :parent => @child_1)
      @child_1_3 = TreeNode.create(:name => 'child 1 3', :parent => @child_1)


      @child_2_1 = TreeNode.create(:name => 'child 2 1', :parent => @child_2)
      @child_2_1_1 = TreeNode.create(:name => 'child 2 1 1', :parent => @child_2_1)
      @child_2_1_1_1 = TreeNode.create(:name => 'child 2 1 1 1', :parent => @child_2_1_1)
    end
    should 'have created root' do
      assert 10, TreeNode.count
    end

    context 'root' do
      should 'be the same @root' do
        assert_equal @root, @root.root
      end
      should 'be found from every level' do
        assert_equal @root, @child_1.root
        assert_equal @root, @child_2_1.root
        assert_equal @root, @child_2_1_1.root
        assert_equal @root, @child_2_1_1_1.root
      end
    end

    context 'siblings' do
      should 'have no siblings for root' do
        assert_equal [], @root.siblings
      end

      should 'have no children as well' do
        assert_equal [], @child_2_1.siblings
      end

      should 'have siblings for @child_2' do
        assert_equal [@child_1, @child_3], @child_2.siblings
      end
      should 'have siblings for @child_1_1' do
        assert_equal [@child_1_2, @child_1_3], @child_1_1.siblings
      end
    end

    context 'siblings and self' do
      should 'include self' do
        assert_equal [@root], @root.self_and_siblings
      end
    end

    context 'ancestors' do
      should 'not have an ancestor for root' do
        assert_equal [], @root.ancestors
      end

      should 'have ancestors in correct order' do
        assert_equal [@child_2, @root], @child_2_1.ancestors
      end
    end

    context 'self and ancestors' do
      should 'have just root for root' do
        assert_equal [@root], @root.self_and_ancestors
      end

      should 'habe self and then ancestors in correct order' do
        assert_equal [@child_2_1_1_1, @child_2_1_1, @child_2_1, @child_2, @root], @child_2_1_1_1.self_and_ancestors
      end
    end

    context 'is ancestor of' do
      should 'root is ancestor of everyone' do
        assert @root.ancestor_of?(@child_1)
        assert @root.ancestor_of?(@child_2_1)
      end

      should 'noone is ancestor of root' do
        assert !@child_1.ancestor_of?(@root)
        assert !@child_2_1_1_1.ancestor_of?(@root)
      end
    end

    context 'is descendant of' do
      should 'root is descendant of noone' do
        assert !@root.descendant_of?(@child_1)
        assert !@root.descendant_of?(@child_2_1)
      end

      should 'everyone is descendant of root' do
        assert @child_1.descendant_of?(@root)
        assert @child_2_1_1_1.descendant_of?(@root)
      end
    end

    context 'depth' do
      should 'be 0' do
        assert_equal 0, @root.depth
      end
      should 'be one' do
        assert_equal 1, @child_1.depth
        assert_equal 1, @child_2.depth
        assert_equal 1, @child_3.depth
      end
      should 'be two' do
        assert_equal 2, @child_1_1.depth
        assert_equal 2, @child_1_2.depth
        assert_equal 2, @child_1_3.depth

        assert_equal 2, @child_2_1.depth
      end

      should 'be three' do
        assert_equal 3, @child_2_1_1.depth
      end
      should 'be four' do
        assert_equal 4, @child_2_1_1_1.depth
      end
    end

  end
end
