# module ActionDispatch
#   class Request
#     self.parameter_parsers = {
#       Mime[:json].symbol => -> (raw_post) {
#         data = ActiveSupport::JSON.decode(ActiveSupport::Gzip.decompress(raw_post))
#         data.is_a?(Hash) ? data : { _json: data }
#       }
#     }
#   end
# end
