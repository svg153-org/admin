.DEFAULT_GOAL := help

help:
	@echo "Usage: make [target] repo_name=<name>"
	@echo ""
	@echo "Targets:"
	@echo "  new-repo            Create a new repository"
	@echo "  add-label-to-repo   Add a label to a repository"
	@echo "  add-label-to-all    Add a label to all repositories"

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
	@echo "Create new branch for all-label-to-all"
	@git switch -c all-label-to-all
	@echo "Add label to all repositories"
	@ yq eval '.labels += [{"name": "label-all-repos", "description": "Added by safe-setting", "color": "ededed"}]' -i .github/settings.yml
	@echo "Label added"
	@git add .github/settings.yml
	@git commit -m "Add label to all repositories"
	@git push -u origin all-label-to-all
	@echo "Configuration pushed"
	@gh pr create --title "Add label to all repositories" --body "Add label to all repositories" --fill
	@echo "Pull request created"
	@gh pr view --web
	@git switch main
	@git branch -D all-label-to-all
