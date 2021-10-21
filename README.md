# gitpod with Tailscale connectivity
This repository contains a simple [Gitpod container](https://www.gitpod.io/)
which can connect the running VM to a [Tailscale network](https://tailscale.com).

You need to create a [Reusable Authkey](https://login.tailscale.com/admin/settings/authkeys)
for your Tailnet and add it as a [Gitpod Variable](https://gitpod.io/variables)
named `TAILSCALE_AUTHKEY`.

Then launch your Gitpod!
