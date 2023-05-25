#!/bin/bash

# Function to test mirror speed
test_mirror_speed() {
    local mirror="$1"
    local speed=$(curl -o /dev/null -s -w "%{speed_download}\n" "http://$mirror/archlinux/iso/latest/archlinux-bootstrap-2021.09.01-x86_64.tar.gz")
    echo "$speed $mirror"
}

# Fetch a list of mirrors
mirrorlist_url="https://archlinux.org/mirrorlist/all/"
tmp_mirrorlist="/tmp/mirrorlist"
curl -s "$mirrorlist_url" | sed 's/^#Server/Server/' > "$tmp_mirrorlist"

# Uncomment the desired protocol and country
# sed -i 's/^#\(Server = http\)/\1/' "$tmp_mirrorlist"
# sed -i '/^#Server = http/ s/$/example_country/' "$tmp_mirrorlist"

# Test mirror speed and select the fastest one
fastest_mirror=""
fastest_speed=0
while read -r mirror; do
    speed=$(test_mirror_speed "$mirror")
    if (( $(echo "$speed > $fastest_speed" | bc -l) )); then
        fastest_mirror="$mirror"
        fastest_speed="$speed"
    fi
done < "$tmp_mirrorlist"

# Generate the pacman mirrorlist
output_file="/etc/pacman.d/mirrorlist"
echo "Server = $fastest_mirror" > "$output_file"

echo "The fastest mirror is: $fastest_mirror"
echo "Mirrorlist generated at: $output_file"
