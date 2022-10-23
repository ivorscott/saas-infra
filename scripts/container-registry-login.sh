#!/bin/bash
# This script automates Github Container Registry login.

cat .ghcr.token | docker login ghcr.io -u ivorscott --password-stdin