require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'holiday_japan'
  gem 'graphql-client'
end

require 'graphql/client'
require 'graphql/client/http'

module GitHubAPI
  GITHUB_ENDPOINT = 'https://api.github.com/graphql'
  HTTP = GraphQL::Client::HTTP.new(GITHUB_ENDPOINT) do
    def headers(context)
      {
        "Authorization" => "Bearer #{ENV['ACCESS_TOKEN']}"
      }
    end
  end
  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

class GhIssue
  QUERY = GitHubAPI::Client.parse <<-GraphQL
    query {
      repository(owner: "kenzo-tanaka", name: "nextJsBlog") {
        issues(
          first: 3
          orderBy: { field: CREATED_AT, direction: DESC }
          labels: "article-publish"
          states: OPEN
        ) {
          nodes {
            title
            body
            updatedAt
            number
          }
        }
      }
    }
  GraphQL

  def self.call
    res = exec_query
    res.data.repository.issues.nodes
  end

  def self.exec_query
    GitHubAPI::Client.query(QUERY)
  end
end

nodes = GhIssue.call
root_dir = ENV['DIR'] ? ENV['DIR'] : '.'

nodes.each do |node|
  md_body = <<~TEXT
    ---
    title: '#{node.title}'
    date: '#{node.updated_at}'
    category: 'dev'
    ---
    #{node.body}
  TEXT

  dir = "#{root_dir}/gh_issue_#{node.number}"
  Dir.mkdir(dir, 0777) unless Dir.exist?(dir)
  File.open("#{dir}/index.md", "w") { |f| f.print md_body }
end
