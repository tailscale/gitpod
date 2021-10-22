# Copyright (c) 2021 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM gitpod/workspace-full:latest
RUN brew install fzf

RUN mkdir /tmp/tsdownload
ENV TSFILE=tailscale_1.16.1_amd64.tgz
RUN wget -O- -q https://pkgs.tailscale.com/stable/${TSFILE} | \
  tar -xz -f - --strip-components=1 -C /tmp/tsdownload

USER root
COPY tailscale.sh /usr/sbin/tailscale.sh
RUN mv /tmp/tsdownload/tailscaled /usr/sbin/tailscaled && \
    mv /tmp/tsdownload/tailscale /usr/bin/tailscale && \
    rm -rf /tmp/tsdownload
RUN mkdir -p /run/tailscale /var/cache/tailscale /var/lib/tailscale
RUN chown gitpod:gitpod /run/tailscale /var/cache/tailscale /var/lib/tailscale
ENV ALL_PROXY=socks5://localhost:1055/
ENV HTTP_PROXY=localhost:1080
ENV http_proxy=localhost:1080
