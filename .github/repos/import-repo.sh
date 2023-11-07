#!/bin/bash


function import_repo() {
    local repo_info=$1
    local repo_file=$2

    echo "repository:" >> ${repo_file}
    echo "  name: ${repo_name}" >> ${repo_file}
    add_repo_info \
        "${repo_info}" \
        "${repo_file}" \
        "${org_name}" \
        "${repo_name}"
}

function add_repo_info() {
    local repo_info=$1
    local repo_file=$2
    local org_name=$3
    local repo_name=$4

    props=(
        private
        visibility
        has_issues
        has_projects
        has_wiki
        default_branch
        gitignore_template
        license_template
        allow_squash_merge
        allow_merge_commit
        allow_rebase_merge
        allow_auto_merge
        delete_branch_on_merge
        archived
    )
    for prop in ${props[@]}; do
        add_repo_info_prop "${repo_info}" "${repo_file}" "${prop}"
    done

    topics=$(gh api repos/${org_name}/${repo_name}/topics | jq -r '.names[]')
    if [ -n "${topics}" ]; then
        echo "  topics:" >> ${repo_file}
        for topic in ${topics}; do
            echo "    - ${topic}" >> ${repo_file}
        done
    fi
    set +x


    echo "  security:" >> ${repo_file}
    enable_security_fixes=$(gh api repos/${org_name}/${repo_name}/automated-security-fixes)
    echo "    enableAutomatedSecurityFixes: $(echo ${enable_security_fixes} | jq -r '.enabled')" >> ${repo_file}
    enable_vulnerability_alerts=$(gh api repos/${org_name}/${repo_name}/vulnerability-alerts 2>/dev/null)
    enable_vulnerability_alerts_message=$(echo ${enable_vulnerability_alerts} | jq -r '.message')
    if [ -n "${enable_vulnerability_alerts}" ] && [ "${enable_vulnerability_alerts_message}" != "Vulnerability alerts are disabled." ]; then
        echo "    enableVulnerabilityAlerts: true" >> ${repo_file}
    fi
}

function add_repo_info_prop() {
    local repo_info=$1
    local repo_file=$2
    local prop=$3

    p=$(echo ${repo_info} | jq --arg prop ${prop} '.[$prop]')
    if [ -n "${p}" ]; then
        echo "  ${prop}: ${p}" >> ${repo_file}
    fi
}

function import_labels() {
    local repo_info=$1
    local repo_file=$2
    local org_name=$3
    local repo_name=$4

    labels=$(gh api repos/${org_name}/${repo_name}/labels)
    if [ -n "${labels}" ] && [ $(echo ${labels} | jq -r '. | length') -gt 0 ]; then
        echo "labels:" >> ${repo_file}
        echo ${labels} \
            | jq -r '.[] | "  - name: \"" + .name + "\"\n    description: \"" + .description + "\"\n    color: \"" + .color + "\""' >> ${repo_file}
    fi

}

function import_teams() {
    local repo_info=$1
    local repo_file=$2
    local org_name=$3
    local repo_name=$4


    teams=$(gh api repos/${org_name}/${repo_name}/teams)

    if [ -n "${teams}" ] && [ $(echo ${teams} | jq -r '. | length') -gt 0 ]; then
        echo "teams:" >> ${repo_file}
        echo ${teams} \
            | jq -r '.[] | "  - name: \"" + .name + "\"\n    permission: \"" + .permission + "\""' >> ${repo_file}
    fi
}

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

org_name="$(git config --get remote.origin.url | sed -E 's/.*github.com[:/](.*)\/.*/\1/')"
repo_name="${1:-repo3}"

repo_file="${SCRIPT_PATH}/${repo_name}.yml"
repo_info=$(gh api repos/${org_name}/${repo_name})

echo "Importing repository ${repo_name} from ${org_name}"

echo "" > ${repo_file}

echo "Repository"
import_repo "${repo_info}" "${repo_file}" "${org_name}" "${repo_name}"

echo "Labels"
import_labels "${repo_info}" "${repo_file}" "${org_name}" "${repo_name}"

echo "Collaborators TODO"

echo "Milestones TODO"

echo "Teams"
import_teams "${repo_info}" "${repo_file}" "${org_name}" "${repo_name}"

echo "Branches TODO"

echo "Autolinks TODO"

echo "Environments TODO"

echo "Repository imported"
