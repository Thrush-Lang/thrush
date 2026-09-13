<img src= "https://github.com/thrustlang/.github/blob/main/assets/logos/new%20logo/thrustlang-logo-banner-text-italic.png" alt= "logo" style= "width: 80%; height: 80%;"></img>

# The Thrust Compiler 

<img src="https://github.com/thrustlang/.github/blob/main/assets/standard-text-separator.png" alt="standard-separator" style="width: 1hv;">

Releasing a new compiler version is handled by the scripts under `scripts/`. There is no need to do anything by hand, the whole release process is divided in three steps: deploy the Rust code documentation, generate the release changelog, and tag the release. Each step has its own script, and the entry point that runs them all in order is `deploy-version`.

Every script comes in four flavors so you can run it on any platform:

- `.sh` for bash (Linux, macOS, WSL).
- `.ps1` for PowerShell (Windows).
- `.fish` for the fish shell.
- `.bat` for the classic Windows command prompt.

> [!NOTE]
> These scripts must be run from inside a git clone of the repository, and they expect a remote named `origin`. They also prompt for input (tag names, push confirmation, and so on), so they are meant to be run interactively.

## Requirements

The release scripts need a few tools that are not part of the compiler itself:

- **`git-cliff`** is used to generate the changelog from the git history. It is configured through the `cliff.toml` file at the root of the project.
- **`sccache`** is used as the rustc wrapper for builds.
- **`panic-analyzer`** is a helper to analyze panics.

You can install the three of them with the `cargo-dependencies` script:

```console
bash scripts/cargo-dependencies.sh
```

There are also `.ps1`, `.fish` and `.bat` versions of that script.

The code documentation step also relies on the `cargo docs` alias defined in `.cargo/config.toml`, which builds rustdoc documentation for thrustc workspace crates while excluding the vendored LLVM crates.

## The release pipeline

The whole process is orchestrated by `deploy-version`, which runs the three steps in order:

```console
=== Step 1/3: Deploying documentation ===
=== Step 2/3: Generating release changelog ===
=== Step 3/3: Tagging release ===
```

Run it with the flavor of your shell:

```console
bash scripts/deploy-version.sh
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts/deploy-version.ps1
```

```fish
fish scripts/deploy-version.fish
```

```console
scripts\deploy-version.bat
```

If any of the steps fails, the pipeline stops there. Each step can also be run on its own if you only want part of the release.

## Step 1. Deploy the code documentation

Script: `deploy-code-docs` (`.sh`, `.ps1`, `.fish`, `.bat`).

This step publishes the Rust code documentation to GitHub Pages, under the `gh-pages` branch.

What it does:

1. Checks if the `gh-pages` branch exists on the `origin` remote. If it does not, it creates it as an orphan branch with an initial empty commit and pushes it.
2. Builds the documentation with `cargo clean --doc` followed by `cargo docs`.
3. Copies the generated `target/doc` folder to a temporary directory and adds an `index.html` that redirects to the main crate page (`thrustc/index.html`).
4. Uses a git worktree of the `gh-pages` branch to replace its contents with the fresh documentation.
5. Commits the changes with a message that includes the current date, and pushes them to `origin`. If there are no documentation changes, nothing is pushed.

> [!NOTE]
> This step does not require any tag, you can run it alone to update the online documentation without doing a release.

## Step 2. Generate the release changelog

Script: `release-changelog` (`.sh`, `.ps1`, `.fish`, `.bat`).

This step creates the changelog for the new version and tags it. It needs `git-cliff` installed and works from the root of the project.

What it does:

1. Creates the `changelogs/` directory if it does not exist.
2. Shows the available tags sorted by version, to help you pick the previous one.
3. Asks you for the **previous tag** (the one the changelog starts from) and validates that it exists.
4. Asks you for the **new tag name** (the version being released).
5. Runs `git-cliff <previous-tag>..HEAD`, generating `changelogs/<new-tag>/README.md` with all the commits in between.
6. Builds the compiler and appends its `--help` output to the changelog under a `## Command Line` section.
7. Commits the changelog with the message `Bumping '<new-tag>'`.
8. Creates the new tag, then pushes both the current branch (`HEAD`) and the new tag to `origin`.

> [!IMPORTANT]
> Both tags are required and are read from the terminal. The previous tag must exist, otherwise the script exits with an error. The new tag should follow the existing naming convention used in the project (for example `thrustc-x86_64-linux-ubuntu-v0.1.5`).

## Step 3. Tag the release

Script: `tag-manager` (`.sh`, `.ps1`, `.fish`, `.bat`).

This step creates the git tag for the release and optionally pushes it to the remote.

What it does:

1. Asks you for the **tag name** and validates that it is not empty.
2. Checks that you are inside a git repository.
3. If the tag already exists locally, deletes it. If it also exists on `origin`, deletes it there too.
4. Creates the new tag on the current commit.
5. Asks `Push to remote? [Y/n]`. Answering anything other than `n` or `N` pushes the tag to `origin`.

> [!NOTE]
> The tag is created on the current `HEAD`. Run this step on the commit you actually want to release, and double check the tag name before confirming the push.

## After the release

Once `deploy-version` finishes, the release is tagged and the documentation is live. You can:

- Check the generated changelog under `changelogs/<tag>/README.md`.
- Create the GitHub release pointing at the new tag, using the changelog as the release notes.
- Update the prebuilt binaries if the project publishes them to GitHub releases.
