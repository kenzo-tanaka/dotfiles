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
  def initialize(pull_requests:)
    @pull_requests = pull_requests
  end

  def average
    result = 0
    @pull_requests.each do |pull_request|
      result += PullRequest.new(data: pull_request).lead_time
    end

    (result / @pull_requests.length).floor 2
  end
end

class PullRequestTest < Minitest::Test
  def test_leadtime
    pull_request = {
      "createdAt" => "2022-03-14T15:00:00Z",
      "mergedAt" => "2022-03-15T05:00:00Z",
      "title" => "Example pr",
      "url" => "https://github.com/test/test/pull/99"
    }
    expected = 14.0
    actual = PullRequest.new(data: pull_request).lead_time
    assert_equal expected, actual
  end

  def test_leadtime2
    pull_request = {
      "createdAt" => "2022-03-10T08:06:16Z",
      "mergedAt" => "2022-03-15T01:46:15Z",
      "title" => "Example pr 2",
      "url" => "https://github.com/test/test/pull/100"
    }
    expected = 113.66
    actual = PullRequest.new(data: pull_request).lead_time
    assert_equal expected, actual
  end
end

class PerformanceTest < Minitest::Test
  def test_average
    pull_requests = [
      {
        "createdAt" => "2022-03-14T12:04:03Z",
        "mergedAt" => "2022-03-15T05:29:21Z",
        "title" => "Example pr",
        "url" => "https://github.com/test/test/pull/99"
      },
      {
        "createdAt" => "2022-03-10T08:06:16Z",
        "mergedAt" => "2022-03-15T01:46:15Z",
        "title" => "Example pr 2",
        "url" => "https://github.com/test/test/pull/100"
      }
    ]
    expected = 65.53
    actual = Performance.new(pull_requests: pull_requests).average
    assert_equal expected, actual
  end
end

