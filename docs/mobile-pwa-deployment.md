# HERMES Mobile PWA Deployment

## Purpose

This document records the HERMES Agent iPhone/PWA deployment used on the
HERMES-AI private ZeroTier network.

The web application remains authenticated by HERMES. Only the static files
required by iOS/PWA installation are served without HERMES authentication.

## Application

Repository branch:

    mobile-pwa

Primary HTTPS endpoint:

    https://10.250.10.10:9444

HERMES dashboard backend:

    http://10.250.10.10:9119

Private network interface:

    ZeroTier / HERMES-AI

## PWA source assets

The authoritative PWA files are:

    web/public/manifest.webmanifest
    web/public/apple-touch-icon.png
    web/public/pwa-192.png
    web/public/pwa-512.png

The production web build is written to:

    hermes_cli/web_dist/

## Public installation assets

iOS may fetch PWA icons outside the authenticated browser session.
Therefore the following files are served directly by Caddy:

    /apple-touch-icon.png
    /pwa-192.png
    /pwa-512.png
    /manifest.webmanifest

Caddy filesystem location:

    /var/lib/caddy/hermes-pwa-public

These files contain no HERMES session data, chat data, credentials, or
application API content.

## Caddy configuration

The HERMES PWA endpoint uses:

```caddy
https://10.250.10.10:9444 {
        bind 10.250.10.10

        tls internal

        @pwa_assets path /apple-touch-icon.png /pwa-192.png /pwa-512.png /manifest.webmanifest

        handle @pwa_assets {
                root * /var/lib/caddy/hermes-pwa-public
                file_server
                header Cache-Control "public, max-age=300"
        }

        handle {
                reverse_proxy 10.250.10.10:9119
        }

        header {
                X-Content-Type-Options nosniff
                X-Frame-Options SAMEORIGIN
                Referrer-Policy no-referrer
        }

        log {
                output file /var/log/caddy/hermes-agent-pwa-access.log
        }
}
