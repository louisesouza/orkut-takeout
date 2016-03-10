require 'rails_helper'

describe Authorizable do

  let(:my_token){"/this is my token/"}

  it 'should store the authentication token prepended by baerer' do
    #setup
    passed_token = "/this is my token/"
    expected_token = "this is my token"
    #exercise
    Authorizable.set_token passed_token
    #verify
    expect(Authorizable.get_token).to eq "bearer " + expected_token
  end

  it "should sign in when I have a token stored" do
    Authorizable.set_token my_token
    expect(Authorizable).to be_signed_in
  end

  it "should sign out when I don't have a token stored" do
    Authorizable.set_token my_token
    Authorizable.clear_token
    expect(Authorizable).to_not be_signed_in
    expect(Authorizable.get_token).to be_nil
  end


end