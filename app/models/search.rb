class Search < ApplicationRecord
  RESOURCES = %w[question answer comment user].freeze

  def self.find(options = {})
    @query = options[:query]
    @resources = options[:resources]
    return if @query.blank? && @resources.blank?

    ThinkingSphinx.search @query, indices: @resources, per_page: 100
  end
end
