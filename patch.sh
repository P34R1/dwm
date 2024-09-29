#!/usr/bin/env bash

# Prompt the user for the filename
read -p "Enter the name for the patch file (without extension): " inputtedText

# Run git diff and redirect the output to the specified file
git diff --cached > "patch/${inputtedText}.diff"
