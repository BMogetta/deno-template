# Deno template
Created from `deno init`. Set up in the way I like it.

# Requirements

- **Deno**

No brainer deno installation and deletion

```shell
make denoinstall
make denodelete
```

# Scripts

`deno task <script_name>`

- cache: cache dependecies and write lock file
- dev: run server in watch mode
- server: run server
- test: run test with coverage output

## Note:
  As a security meause 'run' only works with cache dependecies, so first you have to `deno task cache` and then you can `deno task run`

