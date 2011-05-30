Factory.define :user do |u|
  u.sequence(:username) { |n| "username#{n}" }
  u.gender "M"
  u.birthday "1988-8-8"
  u.country_code 'ja'
end