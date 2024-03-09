vi ~/.config/kungfu/scroll.sh # Editing this file

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

####
# GH Cli
####

gh repo clone repo_url 
gh repo create repo_name --public
gh repo create org/repo_name --private
gh pr list
gh issue list

####
# Flutter
####

flutter pub run flutter_launcher_icons
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter run 

####
# Blogging 
####

BRIDGETOWN__DISABLE_BUILDERS=true bundle exec bridgetown dev
