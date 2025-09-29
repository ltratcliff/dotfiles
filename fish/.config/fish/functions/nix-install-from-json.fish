function nix-install-from-json --description "Installs Nix packages from a 'nix profile list --json' export file"
    # Check if a file path was provided as an argument
    if test -z "$argv[1]"
        echo "Usage: nix-install-from-json <path/to/packages.json>"
        return 1
    end

    set json_file $argv[1]

    # Check if the provided file actually exists
    if not test -e "$json_file"
        echo "Error: File not found at '$json_file'" >&2
        return 1
    end

    # Check if jq is installed, as it's a required dependency
    if not command -v jq >/dev/null
        echo "Error: 'jq' is not installed. Please install it to parse the JSON file." >&2
        echo "You can run: nix-shell -p jq" >&2
        return 1
    end

    # Use jq to parse the JSON and extract the package references
    # The -r flag provides raw string output without quotes
    set packages (jq -r '.elements[].attrPath' "$json_file")

    # Check if any packages were actually found in the file
    if test (count $packages) -eq 0
        echo "Warning: No packages found in '$json_file'. Nothing to install."
        return 0
    end

    # Run the installation command with the extracted package list
    echo "Found (count $packages) packages to install..."
    nix profile add nixpkgs#$packages --impure
end
