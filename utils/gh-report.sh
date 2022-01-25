#!/bin/bash

# TODO: gh command check

# e.g. - [#1 title](https://github.com/test/pull/1)
md_list_format='"- [#" + (.number|tostring) + " " +  .title + "](" + .url + ")"'
gh pr list -a kenzo-tanaka --state closed --json url,title,number -q ".[] | .result = $md_list_format | .result"
