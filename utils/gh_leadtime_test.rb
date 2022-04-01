require 'minitest/autorun'
require 'json'
require 'time'

class PullRequest
  def initialize(data:)
    @data = data
  end

  def lead_time
    ((merged_at - created_at) / 3600).floor 2
  end

  def merged_at
    Time.parse @data['mergedAt']
  end

  def created_at
    Time.parse @data['createdAt']
  end
end

class Performance
  def initialize(name:, pull_requests:)
    @name = name
    @pull_requests = pull_requests
  end

  def lead_time(pull_request)
    PullRequest.new(data: pull_request).lead_time
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
