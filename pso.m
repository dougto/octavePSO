not_func_file = 1

# This is the objective function that we are looking to minimize.
function value = objective_function(x, y)
  value = x*x + y*y
endfunction

# This function gives a random point given an initial point and a range.
function rand_point = get_rand_point(point, range)
  rand_point = range * (rand() * 2 - 1) + point
endfunction

# The following function creates a population given a set of rules.
# Each row of the pop matrix represents an individual, 
# and each column represents one of its attributes:
# [x position, y position, cost, x velocity, y velocity]
function pop = create_population(search_range, search_point, pop_size, max_vel)
  pop = []
  for i = 1:pop_size
    x_position = get_rand_point(search_point(1), search_range)
    y_position = get_rand_point(search_point(2), search_range)
    cost = objective_function(x_position, y_position)
    velocity = [get_rand_point(0, max_vel), get_rand_point(0, max_vel)]
    aux = [x_position, y_position, cost, velocity]
    pop = vertcat(pop, aux) 
  endfor
endfunction

# This function searches for the minimum value
# of cost in all population, which is column 3 of pop matrix.
function best = get_global_best(pop, pop_size)
  best = pop(1,1:5)
  for i = 2:pop_size
   current_individual = pop(i,1:5)
   if best(1,3) > current_individual(1,3)
     best = current_individual
   endif
  endfor
endfunction

# Function to update the velocity of an individual based on the best
# individual position, it's previous position and c1 and c2 constrants
function update_velocity(individual, best_individal, max_vel, c1, c2)
  # x velocity
  v1 = c1 * rand() * (individual(4) - individual(1))
  v2 = c2 * rand() * (best_individal(1) - individual(1))
  individual(4) = individual(4) + v1 + v2
  if (abs(individual(4)) > max_vel)
    if (individual(4) > 0)
      individual(4) = max_vel
    else
      individual(4) = -max_vel
    endif
  endif
  # y velocity
  v1 = c1 * rand() * (individual(5) - individual(2))
  v2 = c2 * rand() * (best_individal(2) - individual(2))
  individual(5) = individual(5) + v1 + v2
  if (abs(individual(5)) > max_vel)
    if (individual(5) > 0)
      individual(5) = max_vel
    else
      individual(5) = -max_vel
    endif
  endif
endfunction

# Function to update position based on the individual's velocity
function update_position(individual)
  # x position
  individual(1) = individual(1) + individual(4)
  # y position
  individual(2) = individual(2) + individual(5)
end

# This is the main loop function on which the best of
# all generations will be found.
function best = search(max_gens, search_range, search_point, pop_size, max_vel, c1, c2)
  pop = create_population(search_range, search_point, pop_size, max_vel)
  best_individal = get_global_best(pop, pop_size)
  for i = 1:max_gens
    for j = 1:pop_size
      individual = pop(j,1:5)
      update_velocity(individual, best_individal, max_vel, c1, c2)
      update_position(individual)
      individual(3) = objective_function(individual(1), individual(2))
    endfor
    best_individal = get_global_best(pop, pop_size)
  endfor
  best = best_individal(1,3)
endfunction

# problem configuration
search_range = 5
search_point = [0,0]
max_gens = 100
pop_size = 50
max_vel = 0.5
c1 = 1
c2 = 4
  
# execute the algorithm
best = search(max_gens, search_range, search_point, pop_size, max_vel, c1,c2)
disp("The minimum found was"), disp(best)
