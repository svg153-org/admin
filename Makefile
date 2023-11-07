.DEFAULT_GOAL := help
.PHONY: help new-repo add-label-to-repo add-label-to-all add-collaborator-to-all make-repo-public

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets for safe-settings demo"
	@echo ""
	@echo "Requirements:"
	@echo "  - gh (GitHub CLI) installed and loged in"
	@echo "  - yq (YAML processor) installed"
	@echo "  - git installed and configured"
	@echo ""
	@echo "Targets:"
	@echo "  new-repo repo_name=<name>                 Create a new repository"
	@echo "  add-label-to-repo repo_name=<name>        Add a label to a repository"
	@echo "  add-label-to-all                          Add a label to all repositories"
	@echo "  add-collaborator-to-all                   Add a collaborator to all repositories"
	@echo "  make-repo-public repo_name=<name>         Make a repository public"
	@echo "  help                                      Show this help"

new-repo:
ifndef repo_name
	$(error repo_name is not set)
endif
	@echo "Create new branch for $(repo_name)"
	@git switch -c new-$(repo_name)
	@mkdir -p .github/repos
	@echo "Create new repository $(repo_name)"
	@touch .github/repos/$(repo_name).yml
	@echo "repository:" >> .github/repos/$(repo_name).yml
	@echo "  name: $(repo_name)" >> .github/repos/$(repo_name).yml
	@echo "  description: Example of a test repository manage by safe-settings" >> .github/repos/$(repo_name).yml
	@echo "  force_create: true" >> .github/repos/$(repo_name).yml
	@echo "  topics:" >> .github/repos/$(repo_name).yml
	@echo "    - safe-settings" >> .github/repos/$(repo_name).yml
	@echo "Repository created"
	@git add .github/repos/$(repo_name).yml
	@git commit -m "Add $(repo_name).yml"
	@git push -u origin new-$(repo_name)
	@echo "Repository pushed"
	@gh pr create --title "New $(repo_name)" --body "Create new $(repo_name)" --fill
	@echo "Pull request created"
	@gh pr view --web
	@git switch main
	@git branch -D new-$(repo_name)

add-label-to-repo:
ifndef repo_name
	$(error repo_name is not set)
endif
	@echo "Create new branch for $(repo_name)"
	@git switch -c add-label-for-$(repo_name)
	@echo "Add label to repository $(repo_name)"
	@echo "" >> .github/repos/$(repo_name).yml
	@echo "labels:" >> .github/repos/$(repo_name).yml
	@echo "  - name: test-label" >> .github/repos/$(repo_name).yml
	@echo "    description: Example of a test label" >> .github/repos/$(repo_name).yml
	@echo "    color: '000000'" >> .github/repos/$(repo_name).yml
	@echo "Label added"
	@git add .github/repos/$(repo_name).yml
	@git commit -m "Add label to $(repo_name)"
	@git push -u origin add-label-for-$(repo_name)
	@echo "Configuration pushed"
	@gh pr create --title "Add label to $(repo_name)" --body "Add label to $(repo_name)" --fill
	@echo "Pull request created"
	@gh pr view --web
	@git switch main
	@git branch -D add-label-for-$(repo_name)

add-label-to-all:
	@echo "Create new branch for add-label-to-all"
	@git switch -c add-label-to-all
	@echo "Add label to all repositories"
	@yq eval '.labels += [{"name": "label-all-repos", "description": "Added by safe-setting", "color": "ededed"}]' -i .github/settings.yml
	@echo "Label added"
	@git add .github/settings.yml
	@git commit -m "Add label to all repositories"
	@git push -u origin add-label-to-all
	@echo "Configuration pushed"
	@gh pr create --title "Add label to all repositories" --body "Add label to all repositories" --fill
	@echo "Pull request created"
	@gh pr view --web
	@git switch main
	@git branch -D add-label-to-all

add-collaborator-to-all:
	@echo "Create new branch for add-collaborator-to-all"
	@git switch -c add-collaborator-to-all
	@echo "Add collaborator to all repositories"
	@yq eval '.collaborators += [{"username": "JavierCane", "permission": "admin"}]' -i .github/settings.yml
	@echo "Collaborator added"
	@git add .github/settings.yml
	@git commit -m "Add collaborator to all repositories"
	@git push -u origin add-collaborator-to-all
	@echo "Configuration pushed"
	@gh pr create --title "Add collaborator to all repositories" --body "Add collaborator to all repositories" --fill
	@echo "Pull request created"
	@gh pr view --web
	@git switch main
	@git branch -D add-collaborator-to-all

make-repo-public:
ifndef repo_name
	$(error repo_name is not set)
endif
	@echo "Create new branch for $(repo_name)"
	@git switch -c make-repo-public-$(repo_name)
	@echo "Make repository $(repo_name) public"
	@yq eval '.repository.private = false' -i .github/repos/$(repo_name).yml
	@echo "Repository made public"
	@git add .github/repos/$(repo_name).yml
	@git commit -m "Make $(repo_name) public"
	@git push -u origin make-repo-public-$(repo_name)
	@echo "Configuration pushed"
	@gh pr create --title "Make $(repo_name) public" --body "Make $(repo_name) public" --fill
	@echo "Pull request created"
	@gh pr view --web
	@git switch main
	@git branch -D make-repo-public-$(repo_name)

import-repo:
	@echo "Create new branch for $(repo_name)"
	@git switch -c import-repo-$(repo_name)
	@echo "Import repository $(repo_name)"
	@cd .github/repos && ./import-repo.sh $(repo_name) && cd ../..
	@echo "Repository imported"
	@git add .github/repos/$(repo_name).yml
	@git commit -m "Import $(repo_name)"
	@git push -u origin import-repo-$(repo_name)
	@echo "Configuration pushed"
	@gh pr create --title "Import $(repo_name)" --body "Import $(repo_name)" --fill
	@echo "Pull request created"
	@gh pr view --web
	@git switch main
	@git branch -D import-repo-$(repo_name)
