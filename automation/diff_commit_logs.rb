#!/usr/bin/ruby
require 'optparse'
require 'set'

require 'git'

def commit_logs(repo)
  logs = repo.log(3000)
  logs.map { |log| [log.message.lines[0].chomp, "[#{log.date.strftime("%Y-%m-%d")}] (#{log.sha}) -- by @#{log.author.name} <#{log.author.email}>"] }.to_h
end

def diff_logs(logs_from_source, logs_from_target)
  lhs = Set.new(logs_from_source.keys)
  rhs = Set.new(logs_from_target.keys)

  puts("=====")

  puts("commits with common: ")
  intersection = lhs.intersection(rhs)
  (intersection).to_a.each do |commit_message|
    puts("#{commit_message.ljust(80, ' ')} #{logs_from_source[commit_message].lines[0]}")
  end
  
  puts("")
  puts("")

  puts("=====")
  puts("commits from source: ")

  (lhs - intersection).to_a.each do |commit_message|
    puts("#{commit_message.ljust(80, ' ')} #{logs_from_source[commit_message].lines[0]}")
  end

  puts("")
  puts("")
  puts("=====")

  puts("commits from target: ")
  (rhs - intersection).to_a.each do |commit_message|
    puts("#{commit_message.ljust(80, ' ')} #{logs_from_target[commit_message].lines[0]}")
  end

  puts("")
  puts("")
end

options = {}
OptionParser.new do |opt|
  opt.on('-s', '--source SOURCE', 'source repository') { |o| options[:source] = o }
  opt.on('-t', '--target TARGET', 'target repository') { |o| options[:target] = o }
end.parse!

lhs = Git.open(File.expand_path(options[:source]))
rhs = Git.open(File.expand_path(options[:target]))

diff_logs(commit_logs(lhs), commit_logs(rhs))
