# Source Packaging

Do not create release archives by right-clicking the whole Windows working
directory and compressing it. That can include `.git/`, local build outputs,
logs, private memory images, and other files that should not be redistributed.

Use `git archive` from a clean repository instead:

```powershell
git archive --format=zip --output ../jyd-rv32i-fpga-core-v0.1.0-source.zip HEAD
```

GitHub-generated "Source code" zip and tar.gz archives also omit `.git/`.

Before publishing any source archive, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check_clean_repo.ps1
git status
git diff --check
```

Do not publish archives containing:

- private memory initialization files such as `.coe` or `.mif`
- Vivado generated products
- bitstreams
- DCP files
- raw logs
- local build directories
- machine-specific paths or credentials

If private verification requires memory images, keep them outside Git release
artifacts and record only a verification summary that does not redistribute
unauthorized files.
