$build = (. .\build); 
Copy-Item $build\* -Destination C:\Users\kingd\OneDrive\Documents\PowerShell\Modules\FreshBuild -Force; 
publish-module -Name FreshBuild -NuGetApiKey $env:PSGalleryApiKey

