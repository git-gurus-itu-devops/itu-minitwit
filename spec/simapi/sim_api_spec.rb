ENV['APP_ENV'] = 'test'

require './simapi/sim_api'
require 'rspec'
require 'rack/test'

RSpec.describe 'Simulator API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def get_login(route)
    get route, {}, 'HTTP_AUTHORIZATION' => 'Basic c2ltdWxhdG9yOnN1cGVyX3NhZmUh'
  end

  def post_login(route, params)
    header "Authorization", "Basic c2ltdWxhdG9yOnN1cGVyX3NhZmUh"
    header "Content-Type", "application/json"
    post route, params
  end

  describe "GET /" do
    it "returns 403 when authorization header is invalid" do
      get "/"
      header "Authorization", "Basic blabla"
      expect(last_response).to be_forbidden
      expect(JSON.parse(last_response.body)).to eq({ 'status' => 403, 'error_msg' => 'You are not authorized to use this resource!' })
    end
  end

  describe "POST /register" do
    before do
      @valid_request = {
        username: "username",
        email: "email@rspec.spec",
        pwd: "pwd"
      }
    end

    it "creates a user when request is valid" do
      post_login "/register", @valid_request.to_json
      expect(last_response).to be_no_content

      # user = User.find_by_username(@valid_request[:username])
      # expect(user).to_not be_nil
      # expect(user.username).to eq(@valid_request[:username])
      # expect(user.email).to eq(@valid_request[:email])
      # expect(user.valid_password?(@valid_request[:password])).to be true

      expect(User.count).to eq(1)
    end
  end
end
