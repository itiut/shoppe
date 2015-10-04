require 'test_helper'

module Shoppe
  class ProductCategoriesTest < ActiveSupport::TestCase

    test "hierarchy_array" do
      parent = create(:parent_category_with_child)
      child = parent.reload.children.first

      assert_equal Array, child.hierarchy_array.class
      assert_equal 2, child.hierarchy_array.count
      assert_equal parent, child.hierarchy_array.first
      assert_equal child, child.hierarchy_array.last
    end

    test "ancestral_permalink" do
      parent = create(:parent_category_with_child)
      child = parent.reload.children.first
      grandchild = create(:product_category, name: 'Grandchild Product Category', parent: child)

      assert_equal parent.permalink, child.ancestral_permalink
      assert_equal "#{parent.permalink}/#{child.permalink}", grandchild.ancestral_permalink

      new_parent = create(:product_category, name: 'New Parent Product Category')
      child.parent = new_parent
      child.save!

      assert_equal new_parent.permalink, child.reload.ancestral_permalink
      assert_equal "#{new_parent.permalink}/#{child.permalink}", grandchild.reload.ancestral_permalink
    end

  end
end
