$script:ModuleRoot = $PSScriptRoot

# Import internal functions and module PSFramework configurations
foreach ($file in (Get-ChildItem "$ModuleRoot\internal" -Filter *.ps1 -Recurse -ErrorAction Ignore)) { . $file.FullName }

# Import Public Functions
foreach ($file in (Get-ChildItem "$ModuleRoot\functions" -Filter *.ps1 -Recurse -ErrorAction Ignore)) { . $file.FullName }

# Import XML View Files
foreach ($file in (Get-ChildItem "$ModuleRoot\xml" -Filter *.ps1 -Recurse -ErrorAction Ignore)) { . $file.FullName }
