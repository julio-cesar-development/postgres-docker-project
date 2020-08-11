#!/bin/sh

"$(which yarn)" run watch &

exec "$@"
