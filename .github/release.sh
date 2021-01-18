#!/bin/bash

VERSION_MAJOR=3
VERSION_SECONDARY=0
VERSION_MINOR=2

TAGS="v${VERSION_MAJOR}  v${VERSION_MAJOR}.${VERSION_SECONDARY}  v${VERSION_MAJOR}.${VERSION_SECONDARY}.${VERSION_MINOR}"
CIRCLE_BRANCH=master

for TAG in ${TAGS}; do
  echo "$TAG"
	TAG_NAME="${TAG}"
	git tag -d "${TAG_NAME}"
	git push origin :refs/tags/"${TAG_NAME}"
	git tag "${TAG_NAME}"
	git push origin ${CIRCLE_BRANCH} --tags
done
