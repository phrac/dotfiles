#!/bin/sh

# Simple script to update cmus library
cmus-remote -C clear
cmus-remote -C "add ~/Music"
cmus-remote -C "update-cache -f"
