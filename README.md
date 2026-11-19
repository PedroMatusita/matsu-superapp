# super_app

A new Flutter project.

## Create and publish a new APK

The GitHub Actions workflow in `.github/workflows/build.yml` automatically builds and signs a release APK whenever a tag matching `v*` is pushed to `origin`.

### One-time setup

Add these repository secrets in **GitHub: Settings > Secrets and variables > Actions**:

- `KEYSTORE_BASE64`
- `KEYSTORE_STORE_PASSWORD`
- `KEYSTORE_KEY_PASSWORD`
- `KEYSTORE_KEY_ALIAS`

### Create and push a tag

Run the following commands from the project root in VS Code's terminal:

1. Check the working tree and make sure it contains only the changes you intend to release:

   ```powershell
   git status
   ```

2. Commit the changes, if you have not committed them yet:

   ```powershell
   git add .
   git commit -m "Prepare release"
   ```

3. Push the current `main` branch to `origin`:

   ```powershell
   git push origin main
   ```

4. Choose the next release version (for example, `v1.0.1`) and create an annotated tag:

   ```powershell
   git tag v1.0.1
   ```

   To list existing tags before choosing a version:

   ```powershell
   git tag --list
   ```

5. Push the tag to `origin`:

   ```powershell
   git push origin v1.0.1
   ```

Pushing the tag starts the **Build APK** workflow. In GitHub, open **Actions**, select the workflow run, and wait for it to finish successfully.

The signed APK is attached to the GitHub release for the tag as `app-release.apk`. If a release with the tag does not exist yet, the workflow creates it automatically.

### If the wrong tag was pushed

Delete the incorrect tag locally and on `origin`, then create the correct tag:

```powershell
git tag -d v1.0.1
git push origin --delete v1.0.1
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
