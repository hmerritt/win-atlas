
# Build the playbook
7z a -tzip -p"malte" -r "Win-Atlas Playbook.apbx" "./src/playbook"

# Copy to, and zip release
Copy-Item -Path "Win-Atlas Playbook.apbx" -Destination "./src/release-zip" -Force
Compress-Archive -Path "./src/release-zip/*" -DestinationPath "./win-atlas.zip"
