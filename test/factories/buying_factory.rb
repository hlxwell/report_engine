Factory.define :buying do |u|
  u.association :user
  u.association :book
  u.amount 2
end