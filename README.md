# Orpheusmorebetter Docker

A Dockerized version of [Orpheusmorebetter](https://github.com/walkrflocka/orpheusmorebetter), built on [python3.13-alpine3.22](https://hub.docker.com/_/python/tags?name=3.13-alpine3.22) image.

📦 Available on [Docker Hub](https://hub.docker.com/r/starkayc/orpheusmorebetter) and [GHCR](https://ghcr.io/starkayc/orpheusmorebetter).

## 📥 Installation (Recommended)

1. **Create `compose.yaml`**:

```yaml
services:
  orpheusmorebetter:
    image: starkayc/orpheusmorebetter
    container_name: orpheusmorebetter
    #command: "-t totp" # For 2FA code
    volumes:
      - ./config:/config/.orpheusmorebetter # Directory where your config are stored.
      - ./data:/data # Directory where your source FLACs, transcodes and torrents are stored.
```

2. **Create folders**:

```bash
mkdir config data
```

3. **Run the container**:

```bash
docker compose up -d
```

4. **Check Logs**:
```bash
docker logs -f orpheusmorebetter
```

## 🛠️ Manual Build (Optional)

If you prefer building the image yourself:

1. **Download Dockerfile**:

```bash
wget https://github.com/starkayc/docker-orpheusmorebetter/blob/main/Dockerfile
```

2. **Build the image**:

```bash
docker build -t orpheusmorebetter .
```

3. **Create folders**:

```bash
mkdir config data
```

4. **Run the container**:

```bash
docker run \
  --name orpheusmorebetter \
  -v "$PWD/config:/config/.orpheusmorebetter" \
  -v "$PWD/data:/data" \
  orpheusmorebetter
```

5. **Check Logs**:  
```bash
docker logs -f orpheusmorebetter
```

## 📥 Configuration

1. **Edit config file at `config/config`**:

```yaml
[orpheus]
username = username
password = password
data_dir = /data/raw
output_dir = /data/transcodes
torrent_dir = /data/torrents
formats = flac, v0, 320
media = cd, vinyl, web
24bit_behaviour = 0
tracker = https://home.opsfet.ch/
mode = both
api = https://orpheus.network/
source = OPS
```

2. **What Settings Do**:

`username` and `password` are your Orpheus login credentials.

`data_dir` is the directory where your source FLACs are stored.

`output_dir` is the directory where your transcodes will be stored after creation. If
the value is blank, `data_dir` will be used. You may also specify
per format values such as `output_dir_320` or `output_dir_v0`, and `orpheusmorebetter` will redirect the outputs to the associated directory.

`torrent_dir` is the directory where the torrents associated with your transcodes will be created (i.e.,
your watch directory). Same per format settings as `output_dir` apply.

`formats` is a list of formats that you'd like to support. (If you don't want to upload V2, or any other specific format, just remove it from this list)

`media` is a list of lossless media types you want to consider for
transcoding. The default value is all What.CD lossless formats, but if
you want to transcode only CD and vinyl media, for example, you would
set this to `cd, vinyl`.

`24bit_behaviour` defines what happens when the program encounters a FLAC
that it thinks is 24bits. If it is set to '2', every FLAC that has a bits-
per-sample property of 24 will be silently re-categorized. If it set to '1',
a prompt will appear. The default is '0' which ignores these occurrences.

`tracker` is the base announce url to use in the torrent files.

`api` is the base url to use for API requests.

`mode` selects which list of torrents `orpheusmorebetter` will use to search for candidates. One of:

 - `snatched` - Your snatched torrents.
 - `uploaded` - Your uploaded torrents.
 - `both`     - Your uploaded and snatched torrents.
 - `seeding`  - Better.php for your seeding torrents.
 - `all`      - All transcode sources above.
 - `none`     - Disable scraping.

 `source` is the source flag to add to created torrents. Leave blank if you are
 running `mktorrent` 1.0.

## 📎 Resources

- Base Image: [python3.13-alpine3.22](https://hub.docker.com/_/python/tags?name=3.13-alpine3.22)  
- Orpheusmorebetter: [walkrflocka/orpheusmorebetter](https://github.com/walkrflocka/orpheusmorebetter)