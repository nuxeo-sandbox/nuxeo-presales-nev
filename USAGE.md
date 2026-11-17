# Advanced Installation

The bootstrap accepts these optional environment variables:

| Variable | Purpose | Default |
| --- | --- | --- |
| `NEV_VERSION` | NEV image version. Prompts if unset. | `2026.4.0` |
| `NUXEO_URL` | Nuxeo URL used by the NEV container. | `http://host.docker.internal:8080/nuxeo` |
| `ENV_NEV_PORT` | Host port for the NEV UI; container port remains `8080`. | `8081` |
| `ENV_NUXEO_AUTHORIZATION_URL` | Browser-facing Nuxeo OAuth authorization URL. | `http://localhost:8080/nuxeo/oauth2/authorize` |
| `NUXEO_SECRET` | OAuth client secret. A UUID is generated if unset. | Generated |
| `NPNEV_BRANCH` | NPN branch to clone. Can also be set with `-b`. | `main` |

Set an override on the command line before running `bootstrap.sh`, for example:

```bash
ENV_NEV_PORT=8082 bash -c "$(curl -fsSL https://raw.githubusercontent.com/nuxeo-sandbox/nuxeo-presales-nev/main/bootstrap.sh)"
```
