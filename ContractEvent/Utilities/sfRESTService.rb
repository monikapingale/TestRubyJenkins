#Created By : Monika Pingale
#Created Date : 18th Jan 2018
#Purpose: This class has methods to test salesforce rest service url's
#Modified date :
require 'httparty'
require 'yaml'
require 'httparty'
class SfRESTService
  @@response = nil
  @@postedData = nil
  def self.loginRequest
    credentials = YAML.load_file(File.expand_path('',Dir.pwd)+'/credentials.yaml')
    #puts "grant type"
    #puts credentails['Staging']['grant_type']
    data = {"grant_type"=>credentials['Staging']['WeWork System Administrator']['grant_type'],"client_id"=>credentials['Staging']['WeWork System Administrator']['client_id'],"client_secret"=>credentials['Staging']['WeWork System Administrator']['client_secret'], "username"=>credentials['Staging']['WeWork System Administrator']['username'],"password"=>"#{credentials['Staging']['WeWork System Administrator']['password']}"}
    @@response = HTTParty.post("https://test.salesforce.com/services/oauth2/token",
                              :body => data,
                              :headers => {"Content-Type":'application/x-www-form-urlencoded'} , verify: false)
     @@response
  end

  def self.getData(id,serviceUrl,loggedIn)
    if !loggedIn then
       @@response = SfRESTService.loginRequest
    end
    url = @@response['instance_url'] + "#{serviceUrl}/#{id}"
    getResponse = HTTParty.get(url,:headers => {"Content-Type":"application/json","Authorization" => "Bearer #{ @@response['access_token']}"} , verify: false)
    return getResponse
  end

  def self.postData(data,serviceUrl,loggedIn)
    if !loggedIn then
       @@response = SfRESTService.loginRequest
    end
    url = "#{@@response['instance_url']}#{serviceUrl}"
    postResponse = HTTParty.post(url,:body => data,:headers => {"Content-Type":"application/json","Authorization":"Bearer #{@@response['access_token']}"} , verify: false)
    #puts postResponse
    #@@postedData = postResponse["result"]
    return postResponse
  end
end
#puts SfRESTService.postData(''+records['scenario1'].to_json,"/services/apexrest/Tour")
#SfRESTService.loginRequest
#puts SfRESTService.getData('a0R3D00000110e0',"/services/apexrest/Tour",false)['tour_id']

