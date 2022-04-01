require 'json'
require 'time'
require 'optparse'

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
opt.parse(ARGV)

# コミッターをコマンドライン引数から取得
users = options[:users].split(',')
from = options[:from]
to = options[:to]

pulls = []
users.each do |name|
  input = `gh pr list -A #{name} --search "merged:#{from}..#{to}" --state merged --json url,title,createdAt,mergedAt`
  pulls << JSON.parse(input)
end

pulls.flatten!
puts Performance.new(pull_requests: pulls).average
