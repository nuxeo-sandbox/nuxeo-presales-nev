# About

Command line tooling for creating and managing a Docker Compose-based stack for
[Nuxeo Enhanced Viewer](https://doc.nuxeo.com/n/QyI).

# Requirements

* [Access to ARender Docker images](https://doc.nuxeo.com/nxdoc/nuxeo-enhanced-viewer-installation/#presentation)
* Docker Engine
* Docker Compose
* Git Command Line

# Usage

To create a brand new project, run the bootstrap script:

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nuxeo-sandbox/nuxeo-presales-nev/main/bootstrap.sh)"
```

This will provide you with a folder that contains (among other things):

* `docker-compose.yml`
* `.env`
* Helpful tooling for managing the stack (e.g. aliases, see below)

After installation is complete, launch the stack with:

```
cd nuxeo-presales-nev && docker compose up -d
```

Follow the logs with:

```
docker compose logs -f
```

* If you install [aliases.sh](aliases.sh) you can do things like:
  * `nev up`
  * `nev down`
  * `nev start`
  * `nev stop`
  * `nev pull`
  * `nev new`
  * `nevui new` to recreate the `ui` container
  * etc.

# Support

**These features are not part of the Nuxeo Production platform.**

These solutions are provided for inspiration and we encourage customers to use them as code samples and learning resources.

This is a moving project (no API maintenance, no deprecation process, etc.) If any of these solutions are found to be useful for the Nuxeo Platform in general, they will be integrated directly into platform, not maintained here.

# License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

# About Nuxeo

More information is available at [https://www.hyland.com/en/solutions/products/nuxeo-platform](https://www.hyland.com/en/solutions/products/nuxeo-platform).
