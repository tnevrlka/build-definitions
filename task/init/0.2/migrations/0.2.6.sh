#!/usr/bin/env bash

set -euo pipefail

# Created for task: init@0.2.6
# Creation time: 2025-12-09T00:00:00Z

declare -r pipeline_file=${1:?missing pipeline file}

# Check if init task exists
if ! yq -e '(.spec.tasks[], .spec.pipelineSpec.tasks[]) | select(.name == "init")' "$pipeline_file" >/dev/null 2>&1; then
    echo "Pipeline does not use init task, skipping migration"
    exit 0
fi

# Add a test parameter to init task using pmt modify (idempotent)
echo "Ensuring test-migration-param exists in init task"
pmt modify -f "$pipeline_file" task "init" add-param test-migration-param "test-value"
