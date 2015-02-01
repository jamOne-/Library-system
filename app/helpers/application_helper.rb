module ApplicationHelper
  # Removes from a hash entries with empty string values
  def remove_empty(hash)
    hash.delete_if { |k, v| v.empty? }
  end
end
