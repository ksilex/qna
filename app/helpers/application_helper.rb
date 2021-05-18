module ApplicationHelper
  def flash_class(level)
    { success: 'alert alert-success alert-dismissible fade show',
      error:   'alert alert-danger alert-dismissible fade show',
      alert:   'alert alert-warning alert-dismissible fade show',
      notice:  'alert alert-info alert-dismissible fade show' }.stringify_keys[level.to_s]
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
