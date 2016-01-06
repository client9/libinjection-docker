# libinjection-docker
A docker-based build/test environment for libinjection

When this Dockerfile changes, a new container is made and pushed to
hub.docker.com via travis.ci

This installs both gcc and clang.  However only one is actually
needed.  Both are used to help shake out errors.

Python unfortunately is needed to regenerate certain files.

