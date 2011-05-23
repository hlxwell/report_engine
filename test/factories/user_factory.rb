Factory.define :user do |u|
  u.sequence(:username) { |n| "username#{n}" }
end