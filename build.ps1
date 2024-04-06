
# Build the playbook
7z a -tzip -p"malte" -r "Atlas Playbook.apbx" "./src/playbook/*"

# Copy to, and zip release
Copy-Item -Path "Atlas Playbook.apbx" -Destination "./src/release-zip" -Force
Compress-Archive -Path "./src/release-zip/*" -DestinationPath "./win-atlas.zip"
