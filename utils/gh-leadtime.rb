require 'json'
require 'time'

require 'optparse'

opt = OptionParser.new
options = {}
opt.on('-u', '--user ITEM', 'user list') { |v| options[:users] = v }
opt.parse(ARGV)

p options

# input = `gh pr list -A kenzo-tanaka --search "merged:2022-03-15" --state merged --json url,title,createdAt,mergedAt`
# results = JSON.parse(input)

# class Person
#   def initialize(name:, pull_requests:)
#     @name = name
#     @pull_requests = pull_requests
#   end

#   def summary_text
#     result = "#{@name}\n"
#     leadtime = 0

#     @pull_requests.each do |pull_request|
#       text = <<~TEXT
#         - #{pull_request['title']} (lead time: #{lead_time(pull_request)} hour)
#       TEXT
#       result += text
#       leadtime += lead_time(pull_request)
#     end
#     leadtime /= @pull_requests.length
#     result += "average lead time: #{leadtime.floor(2)} hour"

#     result
#   end

#   def lead_time(pull_request)
#     merged_at = Time.parse(pull_request['mergedAt'])
#     created_at = Time.parse(pull_request['createdAt'])

#     ((merged_at - created_at) / 3600).floor 2
#   end
# end

# p = Person.new(name: 'kenzo-tanaka', pull_requests: results)
# puts p.summary_text
