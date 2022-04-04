require 'json'
require 'time'
require 'optparse'

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
    Range.new(created_at.to_date, merged_at.to_date).to_a.each do |day|
      seconds += 86400 if day.wday == 0 || day.wday == 6
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
    return 0 if @pull_requests.length == 0

    result = 0
    @pull_requests.each do |pull_request|
      result += PullRequest.new(data: pull_request).lead_time
    end

    (result / @pull_requests.length).floor 2
  end
end

opt = OptionParser.new
options = {}
opt.on('-u', '--users USERS', 'user list') { |v| options[:users] = v }
opt.on('-f', '--from DATE', 'from date') { |v| options[:from] = v }
opt.on('-t', '--to DATE', 'to date') { |v| options[:to] = v }
opt.on('-r', '--res RESPONSE', 'response') { |v| options[:res] = v }
opt.parse(ARGV)

# コミッターをコマンドライン引数から取得
users = options[:users].split(',')
from = options[:from]
to = options[:to]
res = options[:res]

pulls = []
users.each do |name|
  input = `gh pr list -A #{name} --search "merged:#{from}..#{to} base:develop" --state merged --json url,title,createdAt,mergedAt`
  pulls << JSON.parse(input)
end

pulls.flatten!
puts res == 'count'? pulls.length : Performance.new(pull_requests: pulls).average
