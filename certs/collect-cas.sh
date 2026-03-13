#!/usr/bin/env bash

set -e

netskopeCaCert="/Library/Application Support/Netskope/STAgent/data/nscacert.pem"
read -p "Press ENTER to copy the Netskope CA Certificate into your clipboard."

tr -d '\n' < "$netskopeCaCert" | pbcopy
echo "Copied to clipboard. Now edit \`personal.nix\` and add to the list \`tls.trustedCAs\`."


mkcertCaPath="$HOME/.local/share/mkcert/rootCA.pem"
read -p "Press ENTER to copy the mkcert CA Certificate into your clipboard."

tr -d '\n' < "$mkcertCaPath" | pbcopy
echo "Copied to clipboard. Now edit \`personal.nix\` and add to the list \`tls.trustedCAs\`."

