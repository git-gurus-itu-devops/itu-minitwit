if ENV["APP_ENV"] == "test"
  User.create!({username: "testuser", email: "test@user.dk", password: "1234", password_confirmation: "1234"})
end
