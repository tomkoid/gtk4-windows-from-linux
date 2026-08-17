run `instructs.sh` if you use fedora or use docker


```sh
docker build -t gtk4-cross-compiler .
docker run --rm -v "$(pwd):/src" gtk4-cross-compiler
```
