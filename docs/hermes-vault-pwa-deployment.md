# HERMES Knowledge Vault PWA Deployment

## Purpose

This document records the iPhone/PWA deployment for the HERMES-AI Knowledge Vault running on SilverBullet.

The deployment preserves SilverBullet as the application backend while Caddy overrides only the static PWA branding assets required for the custom HERMES Vault Home Screen application.

## Endpoint

Primary HTTPS endpoint:

    https://10.250.10.10:9443

SilverBullet backend:

    http://127.0.0.1:9120

Container:

    hermes-knowledge

Image:

    ghcr.io/silverbulletmd/silverbullet:latest

Vault mount:

    /home/chase/hermes-workspace/obsidian/HERMES-AI -> /space

## Source artwork

Master artwork:

    /home/chase/HERMES_KNOWLEDGE_VAULT.png

Source size:

    1254 x 1254 PNG

## Generated assets

Staging directory:

    /home/chase/hermes-vault-pwa-stage

Production directory:

    /var/lib/caddy/hermes-vault-pwa

Production assets:

    apple-touch-icon.png
    favicon-96x96.png
    logo-dock.png
    manifest.json

Expected image sizes:

    apple-touch-icon.png    180x180
    favicon-96x96.png        96x96
    logo-dock.png           512x512

## SilverBullet native PWA paths

Caddy overrides only:

    /.client/apple-touch-icon.png
    /.client/favicon-96x96.png
    /.client/logo-dock.png
    /.client/manifest.json

All other traffic continues to:

    http://127.0.0.1:9120

## Caddy configuration

The 9443 site is configured so the four branding resources are served from:

    /var/lib/caddy/hermes-vault-pwa

and normal SilverBullet content remains reverse proxied.

Current live endpoint:

    https://10.250.10.10:9443

## Manifest identity

Application name:

    HERMES-AI Knowledge Vault

Short name:

    HERMES Vault

Start URL:

    /#boot

Display mode:

    standalone

Theme color:

    #000000

Background color:

    #000000

## Authentication

SilverBullet authentication remains unchanged.

Only the four static PWA branding files are served directly by Caddy.

Vault notes, APIs, application data, credentials, and authentication material continue through SilverBullet.

Authentication file:

    /home/chase/hermes-workspace/obsidian/HERMES-AI/.silverbullet.auth.json

Authentication values must never be committed to Git.

## iPhone installation

1. Connect the iPhone to the HERMES-AI ZeroTier network.
2. Open Safari.
3. Navigate to https://10.250.10.10:9443
4. Authenticate if required.
5. Select Share.
6. Select Add to Home Screen.
7. Leave Open as Web App enabled.
8. Add HERMES Vault.

## Verification

These resources should return HTTP 200:

    /.client/apple-touch-icon.png
    /.client/favicon-96x96.png
    /.client/logo-dock.png
    /.client/manifest.json

The root URL must continue to load SilverBullet normally.

A normal SilverBullet resource such as:

    /.client/main.css

must continue to proxy from SilverBullet.

## Upgrade resilience

The custom branding files are stored outside the SilverBullet container.

Updating or replacing the SilverBullet container should not erase the custom Vault icon or manifest.

After major SilverBullet, Caddy, or VPS changes, rerun the verification steps.
