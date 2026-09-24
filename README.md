# lemon-manuals for Unraid

Docker image and Unraid template for running the `lemon-website` server against a local copy of the [LEMON manuals](https://lemon-manuals.la/) torrent. LEMON carries newer car service manuals and also includes every [Operation CHARM](https://charm.li/) manual. The site lists the full database at about 1.1 TB: 500 GB for LEMON and 550 GB for CHARM.

The container mounts the torrent's `lemon` and `charm` folders read-only, so the files stay where your torrent client put them and keep seeding.

- Image: [`hellreaver/lemon-manuals`](https://hub.docker.com/r/hellreaver/lemon-manuals) (linux/amd64 only)
- Container port: `8080`, template default host port `16080`

## Requirements

- The LEMON torrent, fully downloaded. You need two folders from it, `lemon` and `charm`, and each one must have an `index.json` at its top level.
- An x86_64 host. The server binary is built for x86_64 glibc, so ARM boxes won't run it.

## Install on Unraid

### Community Applications

1. Open the **Apps** tab and search for `lemon-manuals`.
2. Set **Lemon data** to the torrent's `lemon` folder and **Charm data** to its `charm` folder.
3. Change **Port** if `16080` is taken, then click **Apply**.
4. Open `http://<unraid-ip>:16080/`.

### Manual template

If the app isn't in CA yet, add the template by URL:

1. **Docker** tab, scroll to the bottom, then **Template repositories**.
2. Add `https://github.com/Hellreaver/lemon-manuals-unraid` and click **Save**.
3. **Add Container**, pick `lemon-manuals` from the template list, then follow steps 2 to 4 above.

Example paths, if Deluge saves to `/mnt/user/Deluge/complete`:

| Field      | Host path                                              |
|------------|--------------------------------------------------------|
| Lemon data | `/mnt/user/Deluge/complete/<torrent-folder>/lemon`     |
| Charm data | `/mnt/user/Deluge/complete/<torrent-folder>/charm`     |

## Docker Compose

Edit the two volume paths in `docker-compose.yml`, then:

```sh
docker compose up -d
```

Plain `docker run` does the same thing:

```sh
docker run -d --name lemon-manuals --restart unless-stopped \
  -p 16080:8080 \
  -v /path/to/lemon:/data/lemon:ro \
  -v /path/to/charm:/data/charm:ro \
  hellreaver/lemon-manuals:latest
```

The image's default command is:

```
--listen-address 0.0.0.0:8080 /data/lemon/index.json /data/charm/index.json
```

If you only have one of the two collections, override it and pass only that `index.json`:

```sh
docker run ... hellreaver/lemon-manuals:latest \
  --listen-address 0.0.0.0:8080 /data/lemon/index.json
```

On Unraid, put those arguments in **Post Arguments** (switch the template to Advanced View).

## Building the image

The `lemon-website` binary is not in this repo. Put the Linux build, named `lemon-website-linux-x86_64-glibc`, next to the `Dockerfile` and run:

```sh
docker build -t lemon-manuals .
```

Then swap `image:` for `build: .` in `docker-compose.yml`.

## Troubleshooting

- Start with `docker logs lemon-manuals`.
- Check that both host paths point at the `lemon` and `charm` folders themselves, not their parent, and that `index.json` is directly inside each.
- `exec format error` means the host isn't x86_64.

## License

The files in this repo (Dockerfile, compose file, Unraid templates, README) are MIT licensed; see [LICENSE.md](LICENSE.md). The `lemon-website` binary and the manuals belong to their respective owners and aren't covered by this license.
