#!/bin/bash

set -euo pipefail

if $(sudo sshd -t 2>/dev/null); then
    echo yoyo
else
    echo aboba
fi