# 03-static-site-server

Simple repository with a small static site and a helper `deploy.sh` script that uses `rsync` to publish `my-static-site/` to a remote server. <https://roadmap.sh/projects/static-site-server>

This project also fulfills the roadmap/s Basic DNS Setup, running on Cloudflare, nginx, and GitHub Pages. <https://roadmap.sh/projects/basic-dns>

## Usage

The `deploy.sh` script performs an rsync-based deploy over SSH. It supports two common SSH workflows:

- Explicit key (one-off): pass the private key file via the `SSH_KEY` environment variable.

  Example (WSL / Linux):

  ```bash
  SSH_KEY=~/.ssh/id_rsa ./deploy.sh
  ```

  This is convenient for running the script with a specific private key file.

- Default / agent-based (recommended): if you have your key loaded in an SSH agent or you have a properly permissioned private key in `~/.ssh/` (chmod 600), you do NOT need to set `SSH_KEY` — the script will use the default SSH behavior.

  Example (load into agent once):

  ```bash
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  ./deploy.sh
  ```

Note: Running the script with `SSH_KEY=...` is optional. Use whichever method fits your workflow.
