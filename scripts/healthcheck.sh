#!/usr/bin/env bash
set -e

smbclient -L \\localhost -U % -m SMB3
