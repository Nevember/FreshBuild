
$version=.\build; copy $version\* -Destination C:\Users\kingd\OneDrive\Documents\PowerShell\Modules\FreshBuild -Force;

$build = (. .\build); 
Copy-Item $build\* -Destination C:\Users\kingd\OneDrive\Documents\PowerShell\Modules\FreshBuild -Force; 
publish-module -Name FreshBuild -NuGetApiKey $env:PSGalleryApiKey

find-module FreshBuild
