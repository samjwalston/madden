class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  before_action :handle_gzip_params


  private

  def handle_gzip_params
    #  When the server receives a request with content-type "gzip/json" this will be called which will unzip it,
    #   and then parse it as json
    #  The use case is so clients such as Android or Iphone can zip their long request such as Inviters#addressbook emails
    #  Then the server can unpack the request and parse the parameters as normal.

    if request.content_type == "gzip/json"
      data = ActiveSupport::JSON.decode(ActiveSupport::Gzip.decompress(request.raw_post))
      data = {:_json => data} unless data.is_a?(Hash)
      params ||= {}
      self.params.merge!(data.to_options) #params.merge(data.with_indifferent_access).inject({}){|temp,(k,v)| temp[k.to_sym] = v; temp} # replace string keys with symbols
    end
  end
end
