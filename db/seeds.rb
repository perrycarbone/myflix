# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create!(
  title: 'A Bronx Tale',
  description: 'A boy from the Bronx grows up around the Mafia.',
  small_cover_URL: '/tmp/a_bronx_tale_small.jpg',
  large_cover_URL: '/tmp/a_bronx_tale_large.jpg',
  category_id: 1
  )

Video.create!(
  title: 'Casino',
  description: 'The Mafia invades Las Vegas',
  small_cover_URL: '/tmp/casino_small.jpg',
  large_cover_URL: '/tmp/casino_large.jpg',
  category_id: 2
  )

Video.create!(
  title: 'Donnie Brasco',
  description: 'A boy from the Bronx grows up around the Mafia.',
  small_cover_URL: '/tmp/donnie_brasco_small.jpg',
  large_cover_URL: '/tmp/donnie_brasco_large.jpg',
  category_id: 3
  )

Video.create!(
  title: 'Goodfellas',
  description: 'Two men grow up together in NYC and become part of the family.',
  small_cover_URL: '/tmp/goodfellas_small.jpg',
  large_cover_URL: '/tmp/goodfellas_large.jpg',
  category_id: 4
  )

Video.create!(
  title: 'Scarface',
  description: 'Cuban refugee becomes king of the Miami cocaine business.',
  small_cover_URL: '/tmp/scarface_small.jpg',
  large_cover_URL: '/tmp/scarface_large.jpg',
  category_id: 1
  )

Video.create!(
  title: 'The Godfather',
  description: 'The Corleone family fights to retain control of as head of the five families.',
  small_cover_URL: '/tmp/the_godfather_small.jpg',
  large_cover_URL: '/tmp/the_godfather_large.jpg',
  category_id: 2
  )
