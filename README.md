# docker-protoc
Docker image with Microsoft DirectX shader compiler

Hub: https://hub.docker.com/r/gwihlidal/dxc/

## Usage
```
$ docker run --rm gwihlidal/dxc -help
```

```
$ docker run --rm -v $(pwd):$(pwd) -w $(pwd) gwihlidal/dxc -T <target> -E <entry-point-name> <input-hlsl-file>
```