# frozen_string_literal: true

require_relative './libs/functions_lib'
require_relative './libs/problems_lib'

def calculate_results(data)
  func_root = 0
  k = 0
  result = ''
  while !send(data[:stopping_criteria], {
                limits: data[:limits],
                error: data[:error_margin],
                result: result
              }) && k != data[:maximum_iterations]
    new_limit = (data[:limits][1] - data[:limits][0]) / 2
    k += 1
    round_factor = MAXIMUM_DIGITS - new_limit.to_i.to_s.length
    new_limit = ((data[:limits][0] + data[:limits][1]) / 2).round(round_factor)
    func_root = new_limit
    result = 0
    data[:func_degree].downto(0).each do |i|
      result += (new_limit**i) * data[:coefficients][i]
    end
    data[:limits][0] = new_limit if result.negative?
    data[:limits][1] = new_limit if result.positive?
  end
  [func_root, data[:limits][0], data[:limits][1], k]
end

func_degree, coefficients = fetch_function_data
limits, error_margin, maximum_iterations, index = fetch_problem_data

stopping_criteria = STOPPING_CRITERIA[index]

func_root, lower_limit, higher_limit, iterations = calculate_results({ func_degree: func_degree,
                                                                       coefficients: coefficients,
                                                                       limits: limits,
                                                                       error_margin: error_margin,
                                                                       maximum_iterations: maximum_iterations,
                                                                       stopping_criteria: stopping_criteria })

display_results(func_root, lower_limit, higher_limit, iterations)
