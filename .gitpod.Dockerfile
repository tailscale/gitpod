FROM golang:1.17.2-bullseye AS builder

# Magic DNS in a container where /etc/resolv.conf is a bind mount needed
# extra support, currently on a development branch.
WORKDIR /go/src/tailscale
COPY . ./
RUN git clone https://github.com/tailscale/tailscale.git && cd tailscale && \
    git checkout dgentry/dns-copy && go mod download && \
    go install -mod=readonly ./cmd/tailscaled ./cmd/tailscale
COPY . ./

FROM gitpod/workspace-full:latest
RUN brew install fzf
USER root
COPY tailscaled /etc/init.d
COPY --from=builder /go/bin/tailscaled /usr/sbin/tailscaled
COPY --from=builder /go/bin/tailscale /usr/bin/tailscale

RUN mkdir -p /run/tailscale /var/cache/tailscale /var/lib/tailscale
RUN chown gitpod:gitpod /run/tailscale /var/cache/tailscale /var/lib/tailscale
