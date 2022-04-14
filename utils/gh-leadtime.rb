require 'json'
require 'time'
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
  def initialize(data:)
    @data = data
  end

  def lead_time
    ((merged_at - created_at - weekend_and_holiday) / 3600).floor 2
  end

  def diff
    additions + deletions
  end

  def number
    @data.number
  end

  private

  def weekend_and_holiday
    seconds = 0
    Range.new(created_at.to_date, merged_at.to_date).to_a.each do |date|
      seconds += 86400 if date.wday == 0 || date.wday == 6 || HolidayJapan.check(date)
    end
    seconds
  end

  def merged_at
    @merged_at ||= Time.parse(@data.merged_at).getlocal
  end

  def created_at
    @created_at ||= Time.parse(@data.created_at).getlocal
  end

  def additions
    @data.additions
  end

  def deletions
    @data.deletions
  end
end

class Performance
  # @param [Array<PullRequest>]
  def initialize(pull_requests:)
    @pull_requests = pull_requests
  end

  # @return [Float] リードタイムの平均を返す
  def leadtime_average
    return 0 if @pull_requests.length == 0

    result = 0
    @pull_requests.each do |pull_request|
      result += pull_request.lead_time
    end

    (result / @pull_requests.length).floor 2
  end

  # @return [Integer] diffの平均を返す
  def diff_average
    return 0 if @pull_requests.length == 0

    result = 0
    @pull_requests.each do |pull_request|
      result += pull_request.diff
    end

    (result / @pull_requests.length).floor 2
  end
end

class PullRequests
  QUERY = GitHubAPI::Client.parse <<-GraphQL
    query($query: String!) {
      search(type: ISSUE, query: $query, first: 100) {
        nodes {
          ... on PullRequest {
            number
            createdAt
            mergedAt
            deletions
            additions
          }
        }
      }
    }
  GraphQL

  def initialize(org:, repo:, assignee:, from:, to:, base:)
    @org = org
    @repo = repo
    @assignee = assignee
    @from = from
    @to = to
    @base = base
  end

  # @return [Array<PullRequest>]
  def data
    res = exec_query
    result = []

    res.data.search.nodes.each { result << PullRequest.new(data: _1) }
    result
  end

  private

  def query
    "is:pr is:merged repo:#{@org}/#{@repo} author:#{@assignee} merged:#{@from}..#{@to} base:#{@base}"
  end

  def exec_query
    GitHubAPI::Client.query(QUERY, variables: { query: query })
  end
end

# コミッターをコマンドライン引数から取得
users = ENV['USERS'].split(',')
pulls = []
users.each do |name|
  pull_requests = PullRequests.new(assignee: name, repo: ENV['REPO'], from: ENV['FROM'], to: ENV['TO'], org: ENV['OWNER'], base: ENV['BASE']).data
  pulls << pull_requests
end

pulls.flatten!

nums = pulls.map(&:number)
puts "pulls: #{pulls.length}, nums: #{nums.join(' ')}, leadtime: #{Performance.new(pull_requests: pulls).leadtime_average}, diff_average: #{Performance.new(pull_requests: pulls).diff_average}"
