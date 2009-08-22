module CommonItemsHelper
  def display_amount(user, common_item)
    item = user.items.find_by_common_item_id(common_item.id)
    if item
      "Rs. #{item.default_amount}"
    else
      ""
    end
  end

  def show_delete_link(common_item)
    if current_user == common_item.user
      link_to "Delete", group_common_item_path(common_item.group, common_item), :confirm => 'Are you sure?',:method => :delete
    end
  end
end
