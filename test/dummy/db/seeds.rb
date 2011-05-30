def range_rand(min,max)
  min + rand(max-min)
end

100.times do
  u = User.create(:username => "hlxwell+#{rand(10000)}",
              :gender => %w{W M}[rand(2)],
              :country_code => %w{zh en ja}[rand(3)],
              :birthday => range_rand(10, 30).years.ago.to_date)
  puts "Add user " + u.username
  if rand(2) == 1
    u.books << Book.create(:name => "book - #{rand(1000)}", :price => rand(100))
    puts "create book"
  end
  puts
end