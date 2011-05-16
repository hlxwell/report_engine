Factory.define :user do |u|
  u.sequence(:username) { |n| "username#{n}" }
  u.gender "M"
  u.country_code "zh"
  u.birthday Date.today - 25.years
end