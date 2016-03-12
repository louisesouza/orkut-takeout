require 'rails_helper'

describe OrkutClient do

  let(:sign_in_response){
    sign_in_response = double()
    allow(sign_in_response).to receive(:body).and_return("my token")
    sign_in_response
  }

  let(:current_user_info_response){
    current_user_info_response = double()
    allow(current_user_info_response).to receive(:body).and_return("{}")
    current_user_info_response
  }

  let(:friends_json) {
    %Q([{"_id":"56ab7fc22e481306042c151d","user":{"_id":"56ab7ee72e481306042c1518","name":"QA Couse User 1","email":"qacourseuser1@avenuecode.com"}},{"_id":"56ab7fd22e481306042c151e","user":{"_id":"56ab7ef12e481306042c1519","name":"QA Couse User 2","email":"qacourseuser2@avenuecode.com"}},{"_id":"56ab7fd82e481306042c151f","user":{"_id":"56ab7efb2e481306042c151a","name":"QA Couse User 3","email":"qacourseuser3@avenuecode.com"}},{"_id":"56ab7fe22e481306042c1520","user":{"_id":"56ab7f042e481306042c151b","name":"QA Couse User 4","email":"qacourseuser4@avenuecode.com"}},{"_id":"56ab7fec2e481306042c1521","user":{"_id":"56ab7f102e481306042c151c","name":"QA Couse User 5","email":"qacourseuser5@avenuecode.com"}}])
  }

  let(:friends_info_response){
    friends_info_response = double()
    allow(friends_info_response).to receive(:body).and_return("{}")
    friends_info_response
  }


  it "should sign_in to Orkut Server" do
    #setup
    orkut_client = OrkutClient.new

    #verify
    expect(RestClient).to receive(:post)
                          .with(/login/,
                                hash_including(
                                    username: "lsouza@avenuecode.com",
                                    password: "220489"
                                )
                          ).and_return(sign_in_response)

    #exercise
    orkut_client.sign_in("lsouza@avenuecode.com","220489")
    expect(Authorizable).to be_signed_in
  end

  it "should sign_out from Orkut Server" do
    #setup
    orkut_client = OrkutClient.new

    allow(RestClient).to receive(:post).and_return(sign_in_response)
    orkut_client.sign_in("my_user","my_password")

    #exercise
    orkut_client.sign_out

    #verify
    expect(Authorizable).to_not be_signed_in
  end

  context "#get_current_user_info" do
    it "should throw an exception if the user is not signed in" do
      orkut_client = OrkutClient.new
      expect{ orkut_client.get_current_user_info }.to raise_error(/not signed in/)
    end

    it "should call the get current user info endpoint passing the authentication token" do
      allow(Authorizable).to receive(:signed_in?).and_return(true)
      allow(Authorizable).to receive(:get_token).and_return("my token")

      expect(RestClient::Request).to receive(:execute).with(hash_including(
                                                                method: :get,
                                                                url: /users\/me/,
                                                                headers: { :Authorization => "my token" }
                                                            )).and_return(current_user_info_response)

      orkut_client = OrkutClient.new

      response = orkut_client.get_current_user_info
      expect(response).to be_a(Hash)
    end

    #### get_friends_info _

    it "should call the get my friends info passing the authentication token for current user" do

      allow(Authorizable).to receive(:signed_in?).and_return(true)
      allow(Authorizable).to receive(:get_token).and_return("my token")

      expect(RestClient::Request).to receive(:execute).with(hash_including(
                                                                method: :get,
                                                                url: /friendships\/me/,
                                                                headers: { :Authorization => "my token" }
                                                            )).and_return(friends_info_response)

      orkut_client = OrkutClient.new

      response = orkut_client.get_my_friends
      expect(response).to be_a(Hash)
    end



  end






end