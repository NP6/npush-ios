#!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate --project project.json \
  --outputs Tests/npushTests/MockingbirdMocks \
  --testbundle npushTests \
  --targets npush
