#!/usr/bin/env sh

# Define the SSH key sources
GITHUB_URL="github.com"
GITLAB_URL="gitlab.com"
KNOWN_HOSTS_FILE="$HOME/.ssh/known_hosts"

# Fetch the SSH keys
github_key=$(ssh-keyscan $GITHUB_URL 2>/dev/null)
gitlab_key=$(ssh-keyscan $GITLAB_URL 2>/dev/null)

# Function to update known_hosts
update_known_hosts() {
  key="$1"
  hostname="$2"

  # Remove existing entries for the hostname
  if grep -q "$hostname" "$KNOWN_HOSTS_FILE"; then
    echo "Removing existing entries for $hostname"
    grep -v "$hostname" "$KNOWN_HOSTS_FILE" > "${KNOWN_HOSTS_FILE}.tmp"
    mv "${KNOWN_HOSTS_FILE}.tmp" "$KNOWN_HOSTS_FILE"
  fi

  # Append the new key
  echo "Adding new key for $hostname"
  echo "$key" >> "$KNOWN_HOSTS_FILE"
}

# Ensure the known_hosts file exists
touch "$KNOWN_HOSTS_FILE"

# Update the known_hosts file with the fetched keys
update_known_hosts "$github_key" "$GITHUB_URL"
update_known_hosts "$gitlab_key" "$GITLAB_URL"

# Ensure permissions are correct
chmod 600 "$KNOWN_HOSTS_FILE"

echo "Updated $KNOWN_HOSTS_FILE successfully."
