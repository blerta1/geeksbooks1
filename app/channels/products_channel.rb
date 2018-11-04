class ProductsChannel < ApplicationCable::Channel
  def subscribed
    #streaming updated data all the time
    stream_from "products"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
