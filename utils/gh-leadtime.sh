#!/bin/bash
gh pr list -A kenzo-tanaka --search "merged:2022-03-15" --state merged --json url,title,createdAt,mergedAt
