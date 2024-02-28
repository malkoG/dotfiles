git_logs = `git log --oneline | gum choose --limit 100`

# See https://abhij.it/ruby-difference-between-system-exec-and-backticks/
git_logs.each_line do |line|
  commit_hash, *_ = line.split
  system("git show #{commit_hash}")
  puts("=====")
  puts("Press ENTER key to CONTINUE")
  puts("=====")
  gets
end

checklist = []
git_logs.each_line do |line|
  checklist << "- [ ] #{line}"
end

puts checklist.join
