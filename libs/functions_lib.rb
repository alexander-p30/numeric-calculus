def fetch_function_data
  func_degree = 0
  coefficients = []
  loop do
    func_degree, coefficients = mount_function
    print 'Does your equation look like this? '
    display_function(func_degree, coefficients)
    print " = 0\ny/n: "
    break if gets.chomp.strip == 'y'

    system('clear')
  end
  [func_degree, coefficients]
end

def mount_function
  print "Please state f(x)'s degree (whole number): "
  func_degree = gets.to_i

  coefficients = []
  func_degree.downto(0) do |i|
    print "What's the coefficient for X^#{i}: "
    coefficients.unshift(gets.to_i)
  end

  [func_degree, coefficients]
end

def display_function(func_degree, coefficients)
  func_degree.downto(0) do |i|
    coefficient = coefficients[i]
    func_variable = i.positive? && coefficient != 0 ? "x^#{i}" : ''
    signal = if coefficient.zero? || coefficient == 1
               coefficient = ''
               ''
             else
               coefficient.positive? ? ' + ' : ' - '
             end
    print "#{signal}#{coefficient.to_i.negative? ? coefficient * -1 : coefficient}#{func_variable}"
  end
  nil
end
