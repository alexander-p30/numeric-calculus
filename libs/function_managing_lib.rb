# frozen_string_literal: true

MAXIMUM_DIGITS = 10

# Adds method for proper rounding
class Float
  def round_max_digits
    round(MAXIMUM_DIGITS - to_i.to_s.length)
  end
end

def fetch_function_data
  function = {}
  loop do
    function = mount_function
    print 'Does your equation look like this? '
    display_function(function)
    print " = 0\ny/n: "
    break if gets.chomp.strip == 'y'

    system('clear')
  end
  function
end

def mount_function
  print "Please state f(x)'s degree (whole number): "
  func_degree = gets.to_i

  coefficients = []
  func_degree.downto(0) do |i|
    print "What's the coefficient for X^#{i}: "
    coefficients.unshift(gets.to_i)
  end

  { degree: func_degree, coefficients: coefficients }
end

def display_function(function)
  function[:degree].downto(0) do |i|
    coefficient = function[:coefficients][i]
    func_variable = i.positive? && coefficient != 0 ? "x^#{i}" : ''
    signal = if coefficient.zero? || coefficient == 1
               coefficient = ''
               ''
             else
               coefficient.positive? ? ' + ' : ' - '
             end
    print "#{signal}#{coefficient.to_i.negative? ? coefficient * -1 : coefficient}#{func_variable}"
  end
end

def calculate_function(function, variable_value)
  result = 0
  function[:degree].downto(0).each do |i|
    result += (variable_value**i) * function[:coefficients][i]
  end
  result
end

def calculate_new_limit(data, method)
  methods = { bissection: :new_limit_bissection, false_position: :new_limit_false_position }
  new_limit = send(methods[method], { function: data[:function], limits: data[:limits] })
  new_limit.round_max_digits
end

def new_limit_bissection(function_and_limits)
  (function_and_limits[:limits][1] + function_and_limits[:limits][0]) / 2
end

def new_limit_false_position(function_and_limits)
  function = function_and_limits[:function]
  limits = function_and_limits[:limits]

  higher_result = calculate_function(function, limits[1])
  a = limits[0] * higher_result
  lower_result = calculate_function(function, limits[0])
  b = limits[1] * lower_result

  (a - b) / (higher_result - lower_result)
end

def rearrange_limits(limits, function, func_root)
  approx_root_result = calculate_function(function, func_root)
  lower_limit_result = calculate_function(function, limits[0])

  if (lower_limit_result * approx_root_result).negative?
    limits[1] = func_root
  else
    limits[0] = func_root
  end

  limits
end

def find_approximate_zero(data, method)
  func_root = 0
  k = 0
  result = ''
  current_iteration_data = {}
  while !send(data[:stopping_criterion], current_iteration_data) && k != data[:maximum_iterations]
    k += 1
    func_root = calculate_new_limit(data, method)
    data[:limits] = rearrange_limits(data[:limits], data[:function], func_root)
    current_iteration_data = { limits: data[:limits],
                               error: data[:error_margin],
                               result: result,
                               iteration: k,
                               max_iterations: data[:maximum_iterations] }
  end
  [func_root, k, data[:limits]]
end
