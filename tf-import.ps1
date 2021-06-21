Import-Module powershell-yaml
$repositories = Get-ChildItem -Directory
$nonCookbookRepos = @()
$cookbookRepos = @()
$cb_repo_json_prep = @()
foreach ($repo in $repositories) {
  $metadata_path = "$($repo.FullName)/metadata.rb"
  if (Test-Path $metadata_path) {
    $ci_yaml_path = "$($repo.FullName)/.github/workflows/ci.yml"
    $customChecks = @()
    if (test-path $ci_yaml_path) {
      $customChecks = (get-content $ci_yaml_path -raw | ConvertFrom-Yaml | select-object jobs).jobs.Keys | where { $_ -notin "yamllint", "mdl", "delivery", "integration" }
      $metadataName = get-content $metadata_path | Where { $_ -like "name*" }
      $metadataName -match "^name\s+'(.+)'$" | Out-Null
      if ($repo.Name -ne $Matches[1]) {
        Write-Output "Repo: $($repo.Name) does not match supermarket: $($Matches[1])"
      }
      $repo_json_rep = @{
        name      = $repo.Name
        repo_type = 'cookbook'
      }
      if ($customChecks) {
        $repo_json_rep["additional_status_checks"] = $customChecks
      }
      $cb_repo_json_prep += $repo_json_rep
      Remove-Variable repo_json_rep
    }
    else {
      $customChecks = $null
    }
    # write-output "cookbook: $($repo.name)"
    $cookbookRepos += $repo.name
  }
  else {
    $nonCookbookRepos += $repo.Name
  }
}
$cb_repo_json_prep | ConvertTo-Json | Out-File foo.json
write-output "TF Import Block ****"
foreach ($r in $cookbookRepos) {
  write-output "terraform import module.repository[\`"$r\`"].github_repository.this $r"
  write-output "terraform import module.repository[\`"$r\`"].github_branch.default $r`:main"
  write-output "terraform import module.repository[\`"$r\`"].github_branch_protection.default $r`:main"
  Write-Output ""
}
write-output "notCookbook: $nonCookbookRepos"