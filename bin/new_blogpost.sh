#!/usr/bin/env bash

today=`date +%Y-%m-%d`

echo "Title: "
read title

echo "Slug: "
read slug

mkdir -p content/blog/$slug

cat <<EOF > content/blog/$slug/index.md
+++
fragment = "content"
weight = "100"
date = "$today"
display_date = true
title = "$title"

# categories = []

# [asset]
  # image = ""
  # text = ""
+++
EOF
