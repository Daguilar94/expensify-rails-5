# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

c1 = Category.create(name: 'Car')
c2 = Category.create(name: 'Food')
c3 = Category.create(name: 'Gym')
c4 = Category.create(name: 'Phone')
c5 = Category.create(name: 'Nightlife')

c1.save
c2.save
c3.save
c4.save
c5.save

t1 = Type.create(name: 'Compra')
t2 = Type.create(name: 'Retiro')
t3 = Type.create(name: 'Transferencia')
t4 = Type.create(name: 'Pago')

t1.save
t2.save
t3.save
t4.save

100.times do
  a = Expense.create(
    type_id: rand(1..Type.count),
    category_id: rand(1..Category.count),
    concept: Faker::HowIMetYourMother.quote,
    date: Faker::Time.between(DateTime.now, DateTime.now.months_ago(6)),
    amount: Faker::Number.between(1, 5000000)
  )
  a.save
end
