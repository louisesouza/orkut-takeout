require 'rails_helper'

describe 'OrkutClient' do

  let(:sign_in_response){
    sign_in_response = double()
    allow(sign_in_response).to receive(:body).and_return("my token")
    sign_in_response
  }

  ## stub
  it 'should sign in to Orkut Server' do
    #setup
    orkut_client = OrkutClient.new

    expect(RestClient).to  receive(:post)
                           .with(/login/,
                                 hash_including(username:'lsouza@avenuecode.com',
                                                password:'220489')
                           ).and_return(sign_in_response)
    #exercise
    response = orkut_client.sign_in('lsouza@avenuecode.com', '220489')
  end

  #state base x iteraction base
  it "should sign out from Orkut Server" do
    #setup
    orkut_client = OrkutClient.new
    allow(RestClient).to receive(:post).and_return(sign_in_response)
    orkut_client.sign_in('lsouza@avenuecode.com', '220489')

    #exercise
    orkut_client.sign_out

    #verify
    expect(Authorizable).to_not be_signed_in

  end

end