class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :tagged

  def tagged
  	object.respond_to?(:taggings) ? object.taggings.count : 0
  end
end