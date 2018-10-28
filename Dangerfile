# Warn about master branch
warn("Please target PRs to `develop` branch") if github.branch_for_base != "master"

# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

## changes in the project folder
has_app_changes = !git.modified_files.grep(/iOSProject/).empty?

# Changelog entries are required for changes to library files.
no_changelog_entry = !git.modified_files.include?("CHANGELOG.yml")
if has_app_changes && no_changelog_entry && !declared_trivial
  warn("Any meaningful changes to the project should be reflected in the Changelog. Please consider adding a note there.")
end

# Info.plist file shouldn't change often. Leave warning if it changes.
is_plist_change = git.modified_files.include?("iOSProject/Configuration/Info.plist")

if is_plist_change
  warn "Plist changed, don't forget to localize your plist values"
end
