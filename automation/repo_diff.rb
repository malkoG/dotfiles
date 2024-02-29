require 'set'

def filtered_files(pattern)
  return 'git ls-files' if pattern.empty?

  "git ls-files | rg #{pattern}"
end

source_repo=ARGV[0]
target_repo=ARGV[1]

pattern=ARGV[2]

source_repo_abspath = File.expand_path(source_repo)
target_repo_abspath = File.expand_path(target_repo)

pp source_repo_abspath
pp target_repo_abspath
pp pattern

files_from_source_repo = {}

`cd #{source_repo_abspath} && #{filtered_files(pattern)}`.each_line do |line|
  chomped_line = line.chomp
  files_from_source_repo[chomped_line] = "#{source_repo_abspath}/#{chomped_line}"
end

files_from_target_repo = {}

`cd #{target_repo_abspath} && #{filtered_files(pattern)}`.each_line do |line|
  chomped_line = line.chomp
  files_from_target_repo[chomped_line] = "#{target_repo_abspath}/#{chomped_line}"
end


puts "Scanning all changes......."
puts "...."
puts "...."


changed_files = Set.new(files_from_source_repo.keys) & Set.new(files_from_target_repo.keys)
changed_files.each do |file| 
  next if File.directory?(files_from_target_repo[file])
  changed = !system("delta #{files_from_source_repo[file]} #{files_from_target_repo[file]} --pager cat")
  if changed
    puts "======================"
    puts "Changed!"
    puts "======================"
    # gets
  end
end



not_yet_migrated_files = Set.new(files_from_source_repo.keys) - changed_files
not_yet_migrated_files.each do |file| 
  next if file.include?('b2b')
  next if file.include?('operation')
  puts ""
  puts file
  system("bat #{files_from_source_repo[file]} --style=rule --pager cat")
end

# puts "== SOURCE: #{source_repo_abspath} =="
# puts files_from_source_repo
#
# puts "== TARGET: #{target_repo_abspath} =="
# puts files_from_target_repo
