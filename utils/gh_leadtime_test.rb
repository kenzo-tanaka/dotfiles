require 'minitest/autorun'

class SampleTest < Minitest::Test
  def test_1
    expected = true
    actual = true
    assert_equal expected, actual
  end

  def test_2
    expected = true
    actual = true
    assert_equal expected, actual
  end
end
