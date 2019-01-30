# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(name: 'User', email: 'user@email.com', password: '123456')

30.times do
  todo = user.todos.create!(title: Faker::Lorem.word)
  3.times do
    todo.items.create!(name: Faker::Book.title, done: [true, false].sample)
  end
end

