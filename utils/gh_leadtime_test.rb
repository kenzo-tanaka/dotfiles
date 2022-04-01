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

class PullRequestTest < Minitest::Test
  def test_leadtime
    pull_request = {
      "createdAt" => "2022-03-14T12:04:03Z",
      "mergedAt" => "2022-03-15T05:29:21Z",
      "title" => "Example pr",
      "url" => "https://github.com/test/test/pull/99"
    }
    expected = 17.42
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
