class Api::V1::Admin::TagsController < Api::V1::Admin::AdminController
  
  def index
    tags = Tag.all
    render json: {
        tags: ActiveModelSerializers::SerializableResource.new(tags)
    }
  end
end
