# solana-docker

Docker image for solana development. Includes [bpf-tools](https://github.com/solana-labs/bpf-tools) and [solana image](https://hub.docker.com/r/solanalabs/solana).


Use [`docker load`](https://docs.docker.com/engine/reference/commandline/load/) to create the image.

```console
docker load < solana-bpf.tar.gz
```
```output 
5e6a409f30b6: Loading layer  129.1MB/129.1MB
8faf8d935029: Loading layer  9.298MB/9.298MB
f8b2311dd6f6: Loading layer  661.8MB/661.8MB
Loaded image: deckwill/solana-bpf:latest
```

To use the image run:

```
docker run -it deckwill/solana-bpf
```