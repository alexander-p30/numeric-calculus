# frozen_string_literal: true

# Adds method to check if string can be parsed into a number
class String
  def number?
    !Float(self).nil?
  rescue ArgumentError
    false
  end
end

def filter_input_to_number(format)
  value = ''
  loop do
    value = gets.chomp
    break if value.number?

    print 'Entrada inválida. Insira um número: '
  end
  send(format, value.to_f)
end
