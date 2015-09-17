# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.destroy_all
Category.destroy_all
User.destroy_all

drama = Category.create!(
  name: 'Drama'
  )

horror = Category.create!(
  name: 'Horror'
  )

comedy = Category.create!(
  name: 'Comedy'
  )

romance = Category.create!(
  name: 'Romance'
  )

Video.create!(
  title: 'A Bronx Tale',
  description: 'A boy from the Bronx grows up around the Mafia.',
  small_cover_url: '/tmp/a_bronx_tale_small.jpg',
  large_cover_url: '/tmp/a_bronx_tale_large.jpg',
  category: drama
  )

Video.create!(
  title: 'Casino',
  description: 'The Mafia invades Las Vegas',
  small_cover_url: '/tmp/casino_small.jpg',
  large_cover_url: '/tmp/casino_large.jpg',
  category: drama
  )

Video.create!(
  title: 'Donnie Brasco',
  description: 'A boy from the Bronx grows up around the Mafia.',
  small_cover_url: '/tmp/donnie_brasco_small.jpg',
  large_cover_url: '/tmp/donnie_brasco_large.jpg',
  category: drama
  )

Video.create!(
  title: 'Goodfellas',
  description: 'Two men grow up together in NYC and become part of the family.',
  small_cover_url: '/tmp/goodfellas_small.jpg',
  large_cover_url: '/tmp/goodfellas_large.jpg',
  category: drama
  )

Video.create!(
  title: 'Scarface',
  description: 'Cuban refugee becomes king of the Miami cocaine business.',
  small_cover_url: '/tmp/scarface_small.jpg',
  large_cover_url: '/tmp/scarface_large.jpg',
  category: drama
  )

Video.create!(
  title: 'The Godfather',
  description: 'The Corleone family fights to retain control of as head of the five families.',
  small_cover_url: '/tmp/the_godfather_small.jpg',
  large_cover_url: '/tmp/the_godfather_large.jpg',
  category: drama
  )

Video.create!(
  title: 'Casino',
  description: 'The Mafia invades Las Vegas',
  small_cover_url: '/tmp/casino_small.jpg',
  large_cover_url: '/tmp/casino_large.jpg',
  category: drama
  )

Video.create!(
  title: 'Donnie Brasco',
  description: 'A boy from the Bronx grows up around the Mafia.',
  small_cover_url: '/tmp/donnie_brasco_small.jpg',
  large_cover_url: '/tmp/donnie_brasco_large.jpg',
  category: horror
  )

goodfellas = Video.create!(
  title: 'Goodfellas',
  description: 'Two men grow up together in NYC and become part of the family.',
  small_cover_url: '/tmp/goodfellas_small.jpg',
  large_cover_url: '/tmp/goodfellas_large.jpg',
  category: comedy
  )

Video.create!(
  title: 'Scarface',
  description: 'Cuban refugee becomes king of the Miami cocaine business.',
  small_cover_url: '/tmp/scarface_small.jpg',
  large_cover_url: '/tmp/scarface_large.jpg',
  category: romance
  )

Video.create!(
  title: 'The Godfather',
  description: 'The Corleone family fights to retain control of as head of the five families.',
  small_cover_url: '/tmp/the_godfather_small.jpg',
  large_cover_url: '/tmp/the_godfather_large.jpg',
  category: drama
  )

testuser1 = User.create!(
  full_name: 'Test User 1',
  email_address: 'testuser1@example.com',
  password: 'password'
  )

testuser2 = User.create!(
  full_name: 'Test User 2',
  email_address: 'testuser2@example.com',
  password: 'password'
  )

Review.create!(
  user: testuser1,
  video: goodfellas,
  rating: 5,
  content: "This was a fantastic movie.  I love the mafia!"
  )

Review.create!(
  user: testuser2,
  video: goodfellas,
  rating: 3,
  content: "This move was OK.  I like watching soap operas better."
  )