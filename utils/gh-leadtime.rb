require 'json'
require 'time'
require 'optparse'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'holiday_japan'
  gem 'graphql-client'
end

require 'graphql/client'
require 'graphql/client/http'

module GitHubAPI
  HTTP = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
    def headers(context)
      {
        "Authorization" => "Bearer #{ENV['ACCESS_TOKEN']}"
      }
    end
  end

  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

class PullRequest
  QUERY = GitHubAPI::Client.parse <<-GraphQL
    query($number: Int!, $owner: String!, $name: String!) {
      repository(owner: $owner, name: $name) {
        pullRequest(number: $number) {
          createdAt
          mergedAt
          additions
          deletions
        }
      }
  }
  GraphQL

  def initialize(data:)
    @data = data
  end

  def lead_time
    ((merged_at - created_at - weekend_and_holiday) / 3600).floor 2
  end

  def diff
    res = exec_query(number)
    res.data.repository.pull_request.additions + res.data.repository.pull_request.deletions
  end

  private

  def weekend_and_holiday
    seconds = 0
    Range.new(created_at.to_date, merged_at.to_date).to_a.each do |date|
      seconds += 86400 if date.wday == 0 || date.wday == 6 || HolidayJapan.check(date)
    end
    seconds
  end

  def number
    @data['number']
  end

  def merged_at
    Time.parse(@data['mergedAt']).getlocal
  end

  def created_at
    Time.parse(@data['createdAt']).getlocal
  end

  def exec_query(pull_num)
    GitHubAPI::Client.query(QUERY, variables: { number: pull_num, owner: 'kenzo-tanaka', name: 'dotfiles' })
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

  def diff_average
    return 0 if @pull_requests.length == 0

    result = 0
    @pull_requests.each do |pull|
      result += PullRequest.new(data: pull).diff
    end

    (result / @pull_requests.length).floor 2
  end
end

opt = OptionParser.new
options = {}
opt.on('-u', '--users USERS', 'user list') { |v| options[:users] = v }
opt.on('-b', '--base BRANCH', 'base branch') { |v| options[:base] = v }
opt.on('-f', '--from DATE', 'from date') { |v| options[:from] = v }
opt.on('-t', '--to DATE', 'to date') { |v| options[:to] = v }
opt.on('-o', '--owner OWNER', 'owner name') { |v| options[:owner] = v }
opt.on('-n', '--name NAME', 'repository name') { |v| options[:repo] = v }
opt.parse(ARGV)

# コミッターをコマンドライン引数から取得
users = options[:users].split(',')
from = options[:from]
to = options[:to]
base = options[:base]
owner = options[:owner]
repo = options[:repo]

pulls = []
users.each do |name|
  input = `gh pr list -A #{name} --search "merged:#{from}..#{to} base:#{base}" --state merged --json url,title,createdAt,mergedAt,number`
  pulls << JSON.parse(input)
end

pulls.flatten!
puts "pulls: #{pulls.length}, leadtime: #{Performance.new(pull_requests: pulls).average}, diff_average: #{Performance.new(pull_requests: pulls).diff_average}"
