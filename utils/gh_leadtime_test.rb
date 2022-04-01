require 'minitest/autorun'
require 'json'
require 'time'

class Performance
  def initialize(name:, pull_requests:)
    @name = name
    @pull_requests = pull_requests
  end

  def summary_text
    result = "#{@name}\n"
    return result if @pull_requests.length == 0

    leadtime = 0
    @pull_requests.each do |pull_request|
      text = <<~TEXT
        - #{pull_request['title']} (lead time: #{lead_time(pull_request)} hour)
      TEXT
      result += text
      leadtime += lead_time(pull_request)
    end
    leadtime /= @pull_requests.length
    result += "average lead time: #{leadtime.floor(2)} hour"

    result
  end

  def lead_time(pull_request)
    merged_at = Time.parse(pull_request['mergedAt'])
    created_at = Time.parse(pull_request['createdAt'])

    ((merged_at - created_at) / 3600).floor 2
  end
end

class SampleTest < Minitest::Test
  def test_1
    pull_request = {
      "createdAt" => "2022-03-14T12:04:03Z",
      "mergedAt" => "2022-03-15T05:29:21Z",
      "title" => "Example pr",
      "url" => "https://github.com/test/test/25515"
    }
    expected = 17.42
    actual = Performance.new(name: 'test', pull_requests: {}).lead_time(pull_request)
    assert_equal expected, actual
  end
end
