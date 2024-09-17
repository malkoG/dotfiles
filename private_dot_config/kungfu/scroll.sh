vi ~/.config/kungfu/scroll.sh # Editing this file

####
# Neovim
####
vi ~/.config/nvim/lua/config/mason-lspconfig.lua # LSP configuration
vi ~/.config/nvim/lua/plugins/packer.lua # managing plugins
vi ~/.config/nvim/snippets/ # managing snippets

####
# DevContainer commands
####

devcontainer up --workspace-folder=. --remove-existing-container 

devcontainer exec --workspace-folder=. bin/rails s -b 0.0.0.0 -p 3000
devcontainer exec --workspace-folder=. bin/rails c
devcontainer exec --workspace-folder=. bin/rails db:migrate
devcontainer exec --workspace-folder=. bin/rails tailwindcss:watch

####
# Mise
####

cd ~/.config/mise/ && vi . # Editing mise tasks

#### 
# Journaling
####

export ZETTELKASTEN_TARGET="private_wiki" && ruby -rdate -e "date = Date.today; system(\"cd ~/kojima-wiki && nvim daily/#{date}.md\")" # Open today's journal

####
# Tmuxinator
####

tmuxinator start default
tmuxinator start dotfiles
tmuxinator start blogging

####
# Django
####
poetry shell
poetry run python manage.py runserver
poetry run python manage.py migrate

####
# Git
####

git rebase -i HEAD~6
git navigate
git remote add origin url
git remote remove origin 
git commit --allow-empty -m ""
git log --all --decorate --oneline --graph # Remember a Dog 
git log --decorate --graph --pretty=format:"%h - %an, %ad : %s" --date=short # For briefing

####
# GH Cli
####

gh repo clone repo_url 
gh repo create repo_name --public
gh repo create org/repo_name --private
gh pr list
gh issue list

gh search issues --created '>2023-12-31' --assignee malkoG --state open --json repository,title,id,number,state

####
# Flutter
####

flutter pub run build_runner watch --delete-conflicting-outputs # for re-generating the files
flutter pub run flutter_launcher_icons
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter run 

xcrun simctl erase all # Resetting the simulator and clear caches

####
# Blogging 
####

BRIDGETOWN__DISABLE_BUILDERS=true bundle exec bridgetown dev


#### 
# Todoist
####

todoist --namespace --color l
todoist q "Task name"
todoist list | grep daily
keyword="task"; task_number="$(todoist list | grep $keyword | ruby -ane 'puts "#{$F[0]})"')"; todoist c $task_number;

todoist cl -f today # today's completed tasks

# already existing filter 
todoist list -f "##Inbox | ##개인개발 | ##커뮤니티활동" 
todoist list -f "due:+7days | overdue"
todoist list -f "due:+14days | overdue"
