Factory.define :user do |u|
  u.sequence(:username) { |n| "username#{n}" }
  u.gender %w{W M}[rand(2)]
  u.country_code %w{zh en ja}[rand(3)]
  u.birthday Date.today - rand(30).years
end