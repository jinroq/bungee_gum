## [Unreleased]

## [0.1.3] - 2024-04-26

### Added

- Added the following options.
    - `--with-force-yjit`
    - `--only-force-yjit`
    - `--with-force-rjit`
    - `--only-force-rjit`

### Changed

- Changed from `cppflags=-DRJIT_FORCE_ENABLE` to `--enable-rjit --disable-yjit` that the options used with `--with-rjit' and '--only-rjit`.
- Changed help messages for `--with-universalparser`, `--only-universalparser`, `--with-yjit`, `--only-yjit`, `--with-rjit`, and `--only-rjit`.

## [0.1.2] - 2024-04-08

### Fixed

- Fixed a bug where bungee_gum would not build as expected when run for the first time.
- Revised the README.

## [0.1.1] - 2023-12-12

### Fixed

- Fixed a bug where the program would terminate abnormally if options were not specified.
- Fixed a bug where the `log` directory was not created if it did not exist.
    - Renamed `log` directory to `logs` directory.

## [0.1.0] - 2023-12-06

- Initial release
