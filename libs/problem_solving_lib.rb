# frozen_string_literal: true

STOPPING_CRITERIA = { result: :stop_by_result,
                      difference: :stop_by_difference,
                      iterations: :stop_by_iteration_number,
                      any: :stop_by_any }.freeze

CRITERIA_DESCRIPTION = { result: '|f(x)| < E',
                         difference: '|X[k] - X[k-1] < E',
                         iterations: 'By reaching maximum number of iterations',
                         any: 'Any of the above' }.freeze

def stop_by_result(calc_data)
  result = calc_data[:result]
  error = calc_data[:error]
  return false if result.is_a? String

  result.negative? ? (result * -1) <= error : result <= error
end

def stop_by_difference(calc_data)
  diff = calc_data[:limits][1] - calc_data[:limits][0]
  error = calc_data[:error]
  diff.negative? ? (diff * -1) <= error : diff <= error
end

def stop_by_iteration_number(calc_data)
  calc_data[:iteration] >= calc_data[:max_iterations]
end

def stop_by_any(calc_data)
  stop_by_result(calc_data) || stop_by_difference(calc_data)
end

def fetch_problem_data
  limits = []
  print 'Please state the lower limit: '
  limits << gets.to_f
  print 'Please state the higher limit: '
  limits << gets.to_f

  print 'Please state the error margin`s exponent (10^?): '
  error_margin = 10**gets.to_f

  print 'Please state the maximum number of iterations (-1 for unlimited): '
  maximum_iterations = gets.to_i

  print 'What are the stopping criteria?'
  CRITERIA_DESCRIPTION.values.each_with_index do |criterion_description, index|
    puts "#{index}. #{criterion_description}"
  end
  print('Choose your answer: ')
  criterion = STOPPING_CRITERIA.keys[gets.to_i - 1]

  [limits.sort, error_margin, maximum_iterations, criterion]
end

def display_results(func_root, iterations, limits)
  puts '----------------------------RESULTS----------------------------'
  puts "The new interval is #{limits}, after #{iterations} iterations."
  puts "The approximate root is #{func_root}."
end
