# frozen_string_literal: true

MAXIMUM_DIGITS = 10
STOPPING_CRITERIA = %i[stop_by_result stop_by_difference stop_by_any].freeze

def stop_by_result(calc_data)
  result = calc_data[:result]
  error = calc_data[:error]
  return false if result.is_a? String

  result.negative? ? (result * -1) < error : result < error
end

def stop_by_difference(calc_data)
  diff = calc_data[:limits][1] - calc_data[:limits][0]
  error = calc_data[:error]
  diff.negative? ? (diff * -1) < error : diff < error
end

def stop_by_any(calc_data)
  stop_by_result(calc_data) || stop_by_difference(calc_data)
end

def fetch_problem_data
  print('Please state the lower limit: ')
  lower_limit = gets.to_f

  print('Please state the higher limit: ')
  higher_limit = gets.to_f

  print('Please state the error margin`s exponent (10^?): ')
  error_margin = 10**gets.to_f

  print('Please state the maximum number of iterations (-1 for unlimited): ')
  maximum_iterations = gets.to_i

  print("What are the stopping criteria?\n1. |f(x)| < E\n2. |X[k] - X[k-1] < E\n3. both\nChoose your answer: ")
  stopping_criteria = gets.to_i - 1


  [[lower_limit, higher_limit], error_margin, maximum_iterations, stopping_criteria]
end

def display_results(func_root, lower_limit, higher_limit, iterations)
  puts '----------------------------RESULTS----------------------------'
  puts "The new interval is [#{lower_limit}, #{higher_limit}], after #{iterations} iterations."
  puts "The approximate root is #{func_root}."
end
