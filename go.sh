#!/bin/bash -e

## Installs golang binaries.

GO111MODULE="on" go install sigs.k8s.io/kind@v0.8.0
