require 'minitest/autorun'
require 'json'
require 'time'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'holiday_japan'
end

class PullRequest
  def initialize(data:)
    @data = data
  end

  def lead_time
    ((merged_at - created_at - weekend_seconds) / 3600).floor 2
  end

  private

  def weekend_seconds
    seconds = 0
    Range.new(created_at.to_date, merged_at.to_date).to_a.each do |date|
      seconds += 86400 if date.wday == 0 || date.wday == 6 || HolidayJapan.check(date)
    end
    seconds
  end

  def merged_at
    Time.parse(@data['mergedAt']).getlocal
  end

  def created_at
    Time.parse(@data['createdAt']).getlocal
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
  # 平日間の場合
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

  # 土日を1回挟む場合
  def test_leadtime2
    pull_request = {
      "createdAt" => "2022-03-11T03:00:00Z",
      "mergedAt" => "2022-03-14T05:00:00Z",
      "title" => "Example pr",
      "url" => "https://github.com/test/test/pull/99"
    }
    # 12 + 14
    expected = 26.0
    actual = PullRequest.new(data: pull_request).lead_time
    assert_equal expected, actual
  end

  # 祝日、土日を1回挟む場合
  def test_leadtime_with_holiday
    pull_request = {
      "createdAt" => "2022-02-10T03:00:00Z",
      "mergedAt" => "2022-02-14T05:00:00Z",
      "title" => "Example pr",
      "url" => "https://github.com/test/test/pull/99"
    }
    # 12 + 14
    # 2/11は祝日なので除外する
    expected = 26.0
    actual = PullRequest.new(data: pull_request).lead_time
    assert_equal expected, actual
  end
end

class PerformanceTest < Minitest::Test
  def test_average
    pull_requests = [
      {
        "createdAt" => "2022-03-14T15:00:00Z",
        "mergedAt" => "2022-03-15T05:00:00Z",
        "title" => "Example pr",
        "url" => "https://github.com/test/test/pull/99"
      },
      {
        "createdAt" => "2022-03-11T03:00:00Z",
        "mergedAt" => "2022-03-14T05:00:00Z",
        "title" => "Example pr",
        "url" => "https://github.com/test/test/pull/99"
      }
    ]

    # (14 + 26) / 2
    expected = 20.0
    actual = Performance.new(pull_requests: pull_requests).average
    assert_equal expected, actual
  end
end

