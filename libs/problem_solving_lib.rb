# frozen_string_literal: true

require_relative './input_format_lib'

STOPPING_CRITERIA = { result: :stop_by_function_result,
                      difference: :stop_by_limits_difference,
                      iterations: :stop_by_iteration_number,
                      any: :stop_by_any }.freeze

CRITERIA_DESCRIPTION = { result: '|f(x)| < E',
                         difference: '|X[k] - X[k-1] < E',
                         iterations: 'By reaching maximum number of iterations',
                         any: 'Any of the above' }.freeze

def stop_by_function_result(calc_data)
  result = calc_data[:result]
  error = calc_data[:error]
  return false if result.is_a? String

  result.negative? ? (result * -1) < error : result < error
end

def stop_by_limits_difference(calc_data)
  diff = calc_data[:limits][1] - calc_data[:limits][0]
  error = calc_data[:error]
  diff.negative? ? (diff * -1) < error : diff < error
end

def stop_by_iteration_number(calc_data)
  calc_data[:iteration] == calc_data[:max_iterations]
end

def stop_by_any(calc_data)
  stop_by_function_result(calc_data) || stop_by_limits_difference(calc_data) || stop_by_iteration_number(calc_data)
end

def fetch_problem_data
  print 'Please state the lower limit: '
  limits = [filter_input_to_number(:Float)]

  print 'Please state the higher limit: '
  limits << filter_input_to_number(:Float)

  print 'Please state the error margin`s exponent (10^?): '
  error_margin = 10**filter_input_to_number(:Integer)

  print 'Please state the maximum number of iterations (-1 for unlimited): '
  maximum_iterations = filter_input_to_number(:Integer)

  print "What are the stopping criteria?\n"
  CRITERIA_DESCRIPTION.values.each_with_index do |criterion_description, index|
    puts "#{index + 1}. #{criterion_description}"
  end
  print "What's your option?: "
  criterion = STOPPING_CRITERIA.keys[filter_input_to_number(:Integer) - 1]

  [limits.sort, error_margin, maximum_iterations, criterion]
end

def display_results(func_root, iterations, limits)
  puts '----------------------------RESULTS----------------------------'
  puts "The new interval is #{limits}, after #{iterations} iterations."
  puts "The approximate root is #{func_root}."
end
