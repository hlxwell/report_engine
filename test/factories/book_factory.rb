Factory.define :book do |u|
  u.sequence(:name) { |n| "book - #{n}" }
  u.price 12.5
end