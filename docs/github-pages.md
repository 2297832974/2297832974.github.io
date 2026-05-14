# GitHub Pages Deployment

## Goal

- Publish the current Flutter `web` build through GitHub Pages.
- Keep deployment automatic so every push to `main` refreshes the live site.

## Repository Model

- GitHub account: `2297832974`
- Pages repository: `2297832974.github.io`
- Site URL: `https://2297832974.github.io/`

Because this is a GitHub user-site repository, the Flutter `web` build is served from the root path and does not need a custom `--base-href`.

## Deployment Flow

1. Push the latest code to the `main` branch.
2. GitHub Actions runs `.github/workflows/deploy-pages.yml`.
3. The workflow installs Flutter, runs `flutter pub get`, and builds `build/web`.
4. The workflow uploads `build/web` as the Pages artifact and deploys it.

## Local Verification

Before pushing a UI change that should go live, run:

```bash
fvm flutter analyze
fvm flutter test
fvm flutter build web --release
```

## Operational Notes

- The first Pages publish may take a short time after the initial push because the repository needs one successful Actions deployment.
- If the live site looks stale, confirm the latest `main` push finished successfully in the repository `Actions` tab.
- This deployment path replaces the earlier requirement to manually host the app from a CentOS or LAN server when the goal is a public shareable preview.
