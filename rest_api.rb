require 'httparty'
require 'digest/sha2'

class MyTestApi
  include HTTParty

  API_KEY = "65f90ef0-9581-0130-935c-3c970e529c4b"
  SECRET = "03801cda3a3fde7561af178344b30531c98873f25d527aaf9828291a0c8fe0e3"

  def auth_headers(request_uri)
    timestamp = Time.now.utc.strftime "%Y-%m-%d %H:%M:%S UTC"
    signature_string = SECRET + request_uri + timestamp
    digest = Digest::SHA256.new << signature_string
    signature = digest.to_s
    { "x-api-key" => API_KEY, "x-timestamp" => timestamp, "x-signature" => signature }
  end

  def authenticate_test
    base_url = "http://localhost:3000"
    end_point = "/user/login"
    self.class.get(base_url + end_point, { :headers => auth_headers(end_point) })
  end

end

api = MyTestApi.new
result = api.authenticate_test
puts result
