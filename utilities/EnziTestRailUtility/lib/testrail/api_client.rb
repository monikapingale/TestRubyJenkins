require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module TestRail

  class APIClient

    @url = ''
    @user = ''
    @password = ''

    attr_accessor :user
    attr_accessor :password

    def initialize(base_url)
      base_url += base_url =~ %r{/$} ? '/' : ''
      @url = base_url + 'index.php?/api/v2/'
    end

    #
    # Send Get
    #
    # Issues a GET request (read) against the API and returns the result
    # (as Ruby hash).
    #
    # Arguments:
    #
    # uri                 The API method to call including parameters
    #                     (e.g. get_case/1)
    #
    def send_get(uri)
      _send_request('GET', uri, nil)
    end

    #
    # Send POST
    #
    # Issues a POST request (write) against the API and returns the result
    # (as Ruby hash).
    #
    # Arguments:
    #
    # uri                 The API method to call including parameters
    #                     (e.g. add_case/1)
    # data                The data to submit as part of the request (as
    #                     Ruby hash, strings must be UTF-8 encoded)
    #
    def send_post(uri, data)
      _send_request('POST', uri, data)
    end

    private

    def _secure_channel(conn, url)
      return unless url.scheme == 'https'
      conn.use_ssl = true
      conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def _get_result(response)
      result = if response.body && !response.body.empty?
                 JSON.parse(response.body)
               else
                 {}
               end
      result
    end

    def _send_request(method, uri, data)
      url = URI.parse(@url + uri)
      if method == 'POST'
        request = Net::HTTP::Post.new(url.path + '?' + url.query)
        request.body = JSON.dump(data)
      else
        request = Net::HTTP::Get.new(url.path + '?' + url.query)
      end

      request.basic_auth(@user, @password)
      request.add_field('Content-Type', 'application/json')

      conn = Net::HTTP.new(url.host, url.port)
      _secure_channel(conn, url)

      response = conn.request(request)

      result = _get_result(response)

      if response.code != '200'
        error = if result && result.key?('error')
                  '"' + result['error'] + '"'
                else
                  'No additional error message received'
                end
        raise APIError.new, "TestRail API returned HTTP #{response.code} (#{error})"
      end

      result
    end

  end

  class APIError < StandardError

  end

end
