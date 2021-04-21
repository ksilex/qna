module SearchHelper
  def parent_url(resource)
    resource.parent.class == Question ? resource.parent : resource.parent.question
  end

  def parent_link(resource)
    resource.parent.class == Question ? resource.parent.title : resource.parent&.question&.title
  end
end
