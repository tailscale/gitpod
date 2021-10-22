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
RUN apt-get -y install kmod strace
COPY tailscaled.service /etc/init.d/tailscaled
RUN mv /tmp/tsdownload/tailscaled /usr/sbin/tailscaled && \
    mv /tmp/tsdownload/tailscale /usr/bin/tailscale && \
    rm -rf /tmp/tsdownload
RUN mkdir -p /run/tailscale /var/cache/tailscale /var/lib/tailscale
RUN chown gitpod:gitpod /run/tailscale /var/cache/tailscale /var/lib/tailscale
RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-x86_64 \
    && chmod +x /usr/bin/slirp4netns
