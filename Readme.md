# Azure AI Search Export Script

This Bash script exports all major configuration elements from an [Azure AI Search](https://learn.microsoft.com/en-us/azure/search/search-what-is-azure-search) service—**indexes, indexers, data sources, skillsets, synonym maps, and aliases**—and saves them as individual JSON files. It is intended for use in **Azure Cloud Shell** or **WSL** and is ideal for backup, migration, CI/CD pipelines, or as reference for infrastructure-as-code.

## Features

- Exports all configuration items for a given Azure AI Search service.
- Outputs files in a timestamped, organized directory structure:
`<service-name>-export/<timestamp>/<element>/<name>.json`
- Portable: Works in Azure Cloud Shell, WSL, and most modern Bash environments.
- Minimal dependencies: Requires Azure CLI, curl, and jq.

## Directory Structure Example

```bash
aisandboxaisearch-export/
    20240520-1823/
        indexes/
            my-index.json
        indexers/
            my-indexer.json
        datasources/
            my-datasource.json
        skillsets/
            my-skillset.json
        synonymmaps/
            my-synonymmap.json
        aliases/
            my-alias.json
```

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [jq](https://stedolan.github.io/jq/download/)
- [curl](https://curl.se/)
- Logged in to Azure CLI and have access to the target resource group and search service.

## How to Use

1. **Clone or download this repository.**

2. **Edit the script** and configure these variables at the top:

```bash
    RG="your-resource-group"        # Resource group name
    SERVICE="your-search-service"   # Azure Search service name
    API_VER="2025-05-01-preview"    # API version (adjust if needed)
```

3. **Run the script** in your preferred environment:

```bash
    bash export-azure-search.sh
```

  - The script will create a new export directory named `<service-name>-export/<timestamp>/` with all exported config as JSON files.

4. **Locate your exported configuration** under the generated directory.

## Notes

- Only configuration (not actual index data) is exported.
- Filenames match the resource names. If you have special characters in names, consider sanitizing as needed.
- You can extend the script to archive (zip/tar) or further process the output as required.

## Troubleshooting

- If you see errors about missing commands, ensure `az`, `jq`, and `curl` are installed and in your path.
- Make sure you have appropriate permissions to run `az search admin-key show` on the specified resource group and service.

## License
MIT License

Copyright (c) 2025 Anthony Nevico

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

