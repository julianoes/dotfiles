#!/usr/bin/env bash

git cherry-pick "$(git log origin/master --grep "$1" --pretty=format:"%h")"

