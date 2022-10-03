require 'dotenv/load'
require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/given'
require 'byebug'

Minitest::Reporters.use!

describe 'When Initializing a Workers' do
  context 'efficiency array with 5 workers' do
    Given(:efficiency) { [4, 2, 8, 1, 9] }
    Given(:result) { Workers.new(*efficiency) }
    Then do
      assert_equal 5, result.best_value
    end
  end
end

class Workers
  attr_reader :best_value

  def initialize(*efficiency)
    @best_value = nil
    efficiency.each_with_index do |worker, _index|
      group = efficiency.dup
      group.delete(worker)
      group_values = group.combination(2).to_a.map { |i| (i[0] - i[1]) }
      group_best_value = group_values.reject(&:negative?).sort.reverse[0..1].sum
      @best_value ||= group_best_value
      @best_value = group_best_value if group_best_value < @best_value
    end
    efficiency
    @best_value
  end
end
