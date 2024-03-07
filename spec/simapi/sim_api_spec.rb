ENV['APP_ENV'] = 'test'

require './simapi/sim_api'
require 'rspec'
require 'rack/test'

RSpec.describe 'Simulator API' do
  include Rack::Test::Methods
  include ActiveRecord::TestFixtures
  include ActiveRecord::TestFixtures::ClassMethods

  def app
    Sinatra::Application
  end

  def get_login(route, *)
    header "Authorization", "Basic c2ltdWxhdG9yOnN1cGVyX3NhZmUh"
    header "Content-Type", "application/json"
    header "Connection", "close"
    get route, *
  end

  def post_login(route, *)
    header "Authorization", "Basic c2ltdWxhdG9yOnN1cGVyX3NhZmUh"
    header "Content-Type", "application/json"
    header "Connection", "close"
    post route, *
  end

  before :all do
    ActiveRecord::FixtureSet.create_fixtures('spec/fixtures', :users)
    ActiveRecord::FixtureSet.create_fixtures('spec/fixtures', :messages)
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

      user = User.find_by_username(@valid_request[:username])
      expect(user).to_not be_nil
      expect(user.username).to eq(@valid_request[:username])
      expect(user.email).to eq(@valid_request[:email])
      expect(user.password_digest).to be_present
    end

    it "updates latest" do
      post_login "/register", @valid_request.to_json, query_params: { latest: 1 }
      expect(last_response).to be_no_content
      expect(File.read('./latest_processed_sim_action_id.txt')).to eq("1")
    end
  end

  describe "POST /msgs" do
    before do
      User.create(
        username: "rspec",
        email: "email@rspec.spec",
        password: "pwd",
        password_confirmation: "pwd"
      )
    end

    it "creates a message when request is valid" do
      post_login "/msgs/rspec", { content: "content" }.to_json
      expect(last_response).to be_no_content
    end

    it "updates latest" do
      post_login "/msgs/rspec", { content: "content" }.to_json, query_params: { latest: 1 }
      expect(last_response).to be_no_content
      expect(File.read('./latest_processed_sim_action_id.txt')).to eq("1")
    end
  end

  describe "GET /msgs" do
    before do
      test_user = User.create(
        username: "rspec",
        email: "email@rspec.spec",
        password: "pwd",
        password_confirmation: "pwd"
      )

      test_user.messages.create([
        { text: "content1", flagged: false },
        { text: "content2", flagged: false },
        { text: "content3", flagged: false },
        { text: "flagged", flagged: true }
      ])
    end

    it 'does not include flagged messages' do
      get_login "/msgs/rspec", { no: 3 }
      expect(last_response).to be_ok
      response_json = JSON.parse(last_response.body)

      expect(response_json.length).to eq(3)
      expect(response_json[0]['content']).to eq('content3')
      expect(response_json[1]['content']).to eq('content2')
      expect(response_json[2]['content']).to eq('content1')
    end

    it "returns a list of 'count' messages with newest first" do
      get_login "/msgs/rspec", { no: 3 }
      expect(last_response).to be_ok

      response_json = JSON.parse(last_response.body)

      expect(response_json.length).to eq(3)
      expect(response_json[0]['content']).to eq('content3')
      expect(response_json[1]['content']).to eq('content2')
      expect(response_json[2]['content']).to eq('content1')
    end

    it "updates latest" do
      get_login "/msgs/rspec", { no: 3 }, query_params: { latest: 5 }
      expect(last_response).to be_ok
      expect(File.read('./latest_processed_sim_action_id.txt')).to eq("5")
    end

    it "returns 400 when 'no' is not present" do
      get_login "/msgs/rspec"
      expect(last_response).to be_bad_request
    end
  end
end
