class CpfValidator < ActiveModel::Validator
  def validate(record)
    if record.cpf.present? && !(cpf_is_valid(record.cpf))
      record.errors.add(:cpf, 'inválido')
    end
  end

  private
  def cpf_is_valid(cpf)
    return false if cpf.length != 11
    first_check_digit = calculate_cpf_check_digit(cpf[0..8])
    second_check_digit = calculate_cpf_check_digit(cpf[0..9])
    "#{first_check_digit}#{second_check_digit}" == cpf[9..10]
  end

  def calculate_cpf_check_digit(input)
    sum_of_products = (2..(input.length + 1))
      .to_a
      .reverse
      .zip(input.chars.map(&:to_i))
      .map { |pair| pair[0] * pair[1] }
      .sum

    check_digit = 11 - (sum_of_products % 11)
    check_digit >= 10 ? 0 : check_digit
  end
end
