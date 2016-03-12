require 'rails_helper'

describe 'JSONExporter' do

  let(:json_exporter) {JSONExporter.new}
  let(:current_user_hash) {{"_id" => "56df404993a9a845256d305d",
                            "provider" =>"local",
                            "name" => "Louise",
                            "email" => "lsouza@avenuecode.com",
                            "password"=>"220489",
                            "__v"=>0,
                            "role"=>"user"}}

  let(:friends_hash) {
    JSON.parse(%q([{"_id":"56ab7fc22e481306042c151d","user":{"_id":"56ab7ee72e481306042c1518","name":"QA Couse User 1","email":"qacourseuser1@avenuecode.com"}},{"_id":"56ab7fd22e481306042c151e","user":{"_id":"56ab7ef12e481306042c1519","name":"QA Couse User 2","email":"qacourseuser2@avenuecode.com"}},{"_id":"56ab7fd82e481306042c151f","user":{"_id":"56ab7efb2e481306042c151a","name":"QA Couse User 3","email":"qacourseuser3@avenuecode.com"}},{"_id":"56ab7fe22e481306042c1520","user":{"_id":"56ab7f042e481306042c151b","name":"QA Couse User 4","email":"qacourseuser4@avenuecode.com"}},{"_id":"56ab7fec2e481306042c1521","user":{"_id":"56ab7f102e481306042c151c","name":"QA Couse User 5","email":"qacourseuser5@avenuecode.com"}}]))
  }

## social percentage
  let(:super_friendly_hash){
    friends_array = []

    15.times do
      friends_array << %Q({
	                           "_id": "56ab7fc22e481306042c151d",
                            	"user": {
		                           "_id": "56ab7ee72e481306042c1518",
		                           "name": "QA Couse User 1",
		                           "email": "qacourseuser1@avenuecode.com"
	                            }
	                          })
    end
    friends_string = friends_array.join(",")

    JSON.parse("[#{friends_string}]")
  }

  let(:ten_friends_hash){
    friends_array = []

    10.times do
      friends_array << %Q({
	                           "_id": "56ab7fc22e481306042c151d",
                            	"user": {
		                           "_id": "56ab7ee72e481306042c1518",
		                           "name": "QA Couse User 1",
		                           "email": "qacourseuser1@avenuecode.com"
	                            }
	                          })
    end
    friends_string = friends_array.join(",")

    JSON.parse("[#{friends_string}]")
  }

  let(:friend_hash){
    friends_array = []

      friends_array << %Q({
	                           "_id": "56ab7fc22e481306042c151d",
                            	"user": {
		                           "_id": "56ab7ee72e481306042c1518",
		                           "name": "QA Couse User 1",
		                           "email": "qacourseuser1@avenuecode.com"
	                            }
	                          })
    friends_string = friends_array.join(",")

    JSON.parse("[#{friends_string}]")
  }


  context "content" do
    it 'should include a line containing my email and my password' do
      #exercise
      json_response = json_exporter.export_friends(friends_hash, current_user_hash)
      #verify
      expect(json_response).to include "Louise","lsouza@avenuecode.com"
    end

    it 'should include my friends username and password' do
      #exercise
      json_response = json_exporter.export_friends(friends_hash, current_user_hash)

      #verify
      expect(json_response).to include "QA Couse User 1","qacourseuser1@avenuecode.com"
    end
  end

  context "social percentage" do

    it 'should show 100% as my friends percentage' do
      #exercise
      json_response = json_exporter.export_friends(super_friendly_hash, current_user_hash)
      response_hash = JSON.parse(json_response)

      #verify
      expect(response_hash["user"]["socialPercentage"]).to include "100%"
    end

    it 'should show 66% as my friends percentage' do
      #exercise
      json_response = json_exporter.export_friends(ten_friends_hash, current_user_hash)
      response_hash = JSON.parse(json_response)

      #verify
      expect(response_hash["user"]["socialPercentage"]).to include "66%"
    end

    it "should show my socialType as SUPER FRIENDLY" do
      json_response = json_exporter.export_friends(super_friendly_hash, current_user_hash)
      response_hash = JSON.parse(json_response)

      #verify
      expect(response_hash["user"]["socialType"]).to include "Super Friendly"
    end

    it 'should show my socialType as FRIENDLY' do
      #exercise
      json_response = json_exporter.export_friends(ten_friends_hash, current_user_hash)
      response_hash = JSON.parse(json_response)

      #verify
      expect(response_hash["user"]["socialType"]).to include "Friendly"
    end

    it 'should show my socialType as NOT SO FRIENDLY' do
      #exercise
      json_response = json_exporter.export_friends(friend_hash, current_user_hash)
      response_hash = JSON.parse(json_response)

      #verify
      expect(response_hash["user"]["socialType"]).to include "Not So Friendly"
    end

  end

end