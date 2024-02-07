# In this assignment, you'll be using the domain model from hw1 (found in the hw1-solution.sql file)
# to create the database structure for "KMDB" (the Kellogg Movie Database).
# The end product will be a report that prints the movies and the top-billed
# cast for each movie in the database.

# To run this file, run the following command at your terminal prompt:
# `rails runner kmdb.rb`

# Requirements/assumptions
#
# - There will only be three movies in the database – the three films
#   that make up Christopher Nolan's Batman trilogy.
# - Movie data includes the movie title, year released, MPAA rating,
#   and studio.
# - There are many studios, and each studio produces many movies, but
#   a movie belongs to a single studio.
# - An actor can be in multiple movies.
# - Everything you need to do in this assignment is marked with TODO!

# Rubric
# 
# There are three deliverables for this assignment, all delivered within
# this repository and submitted via GitHub and Canvas:
# - Generate the models and migration files to match the domain model from hw1.
#   Table and columns should match the domain model. Execute the migration
#   files to create the tables in the database. (5 points)
# - Insert the "Batman" sample data using ruby code. Do not use hard-coded ids.
#   Delete any existing data beforehand so that each run of this script does not
#   create duplicate data. (5 points)
# - Query the data and loop through the results to display output similar to the
#   sample "report" below. (10 points)

# Submission
# 
# - "Use this template" to create a brand-new "hw2" repository in your
#   personal GitHub account, e.g. https://github.com/<USERNAME>/hw2
# - Do the assignment, committing and syncing often
# - When done, commit and sync a final time before submitting the GitHub
#   URL for the finished "hw2" repository as the "Website URL" for the 
#   Homework 2 assignment in Canvas

# Successful sample output is as shown:

# Movies
# ======

# Batman Begins          2005           PG-13  Warner Bros.
# The Dark Knight        2008           PG-13  Warner Bros.
# The Dark Knight Rises  2012           PG-13  Warner Bros.

# Top Cast
# ========

# Batman Begins          Christian Bale        Bruce Wayne
# Batman Begins          Michael Caine         Alfred
# Batman Begins          Liam Neeson           Ra's Al Ghul
# Batman Begins          Katie Holmes          Rachel Dawes
# Batman Begins          Gary Oldman           Commissioner Gordon
# The Dark Knight        Christian Bale        Bruce Wayne
# The Dark Knight        Heath Ledger          Joker
# The Dark Knight        Aaron Eckhart         Harvey Dent
# The Dark Knight        Michael Caine         Alfred
# The Dark Knight        Maggie Gyllenhaal     Rachel Dawes
# The Dark Knight Rises  Christian Bale        Bruce Wayne
# The Dark Knight Rises  Gary Oldman           Commissioner Gordon
# The Dark Knight Rises  Tom Hardy             Bane
# The Dark Knight Rises  Joseph Gordon-Levitt  John Blake
# The Dark Knight Rises  Anne Hathaway         Selina Kyle

# Delete existing data, so you'll start fresh each time this script is run.
# Use `Model.destroy_all` code.
# TODO!

Role.destroy_all
Movie.destroy_all
Actor.destroy_all
Studio.destroy_all


# Generate models and tables, according to the domain model.
# TODO!
# done!

# Insert data into the database that reflects the sample data shown above.
# Do not use hard-coded foreign key IDs.
# TODO!

#add studio
warner_bros = Studio.create!(name: "Warner Bros.")

#add movies
batman_begins = Movie.create!(title: "Batman Begins", year_released: 2005, rated: "PG-13", studio: warner_bros)
dark_knight = Movie.create!(title: "The Dark Knight", year_released: 2008, rated: "PG-13", studio: warner_bros)
dk_rises = Movie.create!(title: "The Dark Knight Rises", year_released: 2012, rated: "PG-13", studio: warner_bros)


#add actors and roles
# Helper method to find or create actors by name
def find_or_create_actor(name)
    Actor.find_or_create_by(name: name)
  end
  
  # Helper method to create role
  def create_role(movie, actor_name, character_name)
    actor = find_or_create_actor(actor_name)
    Role.create!(movie: movie, actor: actor, character_name: character_name)
  end
  
  # movie hash assignment
  movies = {
    "Batman Begins" => batman_begins,
    "The Dark Knight" => dark_knight,
    "The Dark Knight Rises" => dk_rises
  }
  
  # define roles for each movie
  roles = {
    "Batman Begins" => [
      ["Christian Bale", "Bruce Wayne"],
      ["Michael Caine", "Alfred"],
      ["Liam Neeson", "Ra's Al Ghul"],
      ["Katie Holmes", "Rachel Dawes"],
      ["Gary Oldman", "Commissioner Gordon"]
    ],
    "The Dark Knight" => [
      ["Christian Bale", "Bruce Wayne"],
      ["Heath Ledger", "Joker"],
      ["Aaron Eckhart", "Harvey Dent"],
      ["Michael Caine", "Alfred"],
      ["Maggie Gyllenhaal", "Rachel Dawes"]
    ],
    "The Dark Knight Rises" => [
      ["Christian Bale", "Bruce Wayne"],
      ["Gary Oldman", "Commissioner Gordon"],
      ["Tom Hardy", "Bane"],
      ["Joseph Gordon-Levitt", "John Blake"],
      ["Anne Hathaway", "Selina Kyle"]
    ]
  }
  
  # Iterate over the roles hash to create roles for each movie
  roles.each do |movie_title, actor_roles|
    movie = movies[movie_title]
    actor_roles.each do |actor_info|
      actor_name, character_name = actor_info
      create_role(movie, actor_name, character_name)
    end
  end


# Prints a header for the movies output
puts "Movies"
puts "======"
puts ""

# Query the movies data and loop through the results to display the movies output.
Movie.includes(:studio).each do |movie|
    puts "#{movie.title} #{movie.year_released} #{movie.rated} #{movie.studio.name}"
  end

# Prints a header for the cast output
puts ""
puts "Top Cast"
puts "========"
puts ""



# Query the cast data and loop through the results to display the cast output for each movie.
# TODO!
movies = Movie.includes(roles: :actor).all

movies.each do |movie|
  # For each movie, iterate over its roles
  movie.roles.each do |role|
    # Print the movie title, actor name, and character name
    puts "#{movie.title} #{role.actor.name} #{role.character_name}"
  end
end



