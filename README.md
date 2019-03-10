# minimal-ade

A minimal example of an ade-compatible project:

```
~/ade-home/
├── .adehome <- Tells ade-cli that this is the root of this ade home
└── minimal-ade
    ├── .aderc <- Tells ade-cli what images and volumes to use
    ├── Dockerfile
    ├── entrypoint
    └── env.sh
```

## Build and start

```
$ cd ~/ade-home/minimal-ade
$ docker build -t image .
$ ade start
```

## Additional recommendations

1. Add `--label ade_image_commit_sha=<git hash>` and/or `--label ade_image_commit_tag=<git-tag>` to `docker build` to embed VCS information in the docker image
2. Additional `docker run` arguments are usually needed to enable some tools (e.g. debuggers and networking tools). e.g. Add the following to `.aderc` to enable `gdb`:
    ```
    export ADE_DOCKER_RUN_ARGS="
      --cap-add=SYS_PTRACE
    "
    ```
