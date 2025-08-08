#!/usr/bin/env bash
set -euo pipefail

# Remove selected Omarchy WebApps using `omarchy-webapp-remove`.
# Edit the WEBAPPS_TO_REMOVE list to include the apps you want to remove.

WEBAPPS_TO_REMOVE=(
  "WhatsApp"
)

if ! command -v omarchy-webapp-remove >/dev/null 2>&1; then
  echo "omarchy-webapp-remove not found. Is Omarchy installed?" >&2
  exit 1
fi

for app in "${WEBAPPS_TO_REMOVE[@]}"; do
  echo "Removing webapp: ${app}"
  if ! omarchy-webapp-remove "${app}"; then
    echo "- Failed to remove '${app}', continuing..." >&2
  fi
done

echo "Done removing selected webapps."