require 'net/http'
require 'json'
module Recaptcha
  private
  def verify_recaptcha(response)
    uri = URI('https://www.google.com/recaptcha/api/siteverify')
    params = { :secret => RECAPTCHA_SECRET_KEY, :response => response }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
   JSON.parse(res.body)["success"] if res.is_a?(Net::HTTPSuccess)
  end
end