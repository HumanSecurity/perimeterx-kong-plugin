# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [4.0.4] - 2025-10-14

### Added

- Add support for enrich_custom_parameters() dynamic function

## [4.0.3] - 2025-07-10

### Added

- Add score_header_enabled conf option

## [4.0.2] - 2025-06-30

### Added

- Add whitelist_hosts conf option

### Changed

- Depend on perimeterx-nginx-plugin v7.3.5

## [4.0.1] - 2024-12-26

### Fixed

- GraphQL default path

### Changed

- Depend on perimeterx-nginx-plugin v7.3.4

## [4.0.0] - 2024-10-24

### Added

- Kong 3.x is now supported

### Changed

- Kong 1.x is no longer supported

## [3.1.2] - 2023-11-08

### Added

- Docker test scripts for various Kong versions

### Changed

- Update configuration schema

## [3.1.1] - 2023-06-13

### Added

- enrich_custom_params

### Changed

- Depend on perimeterx-nginx-plugin v7.3.0

## [3.1.0] - 2023-02-23

### Added

- px_metadata.json

### Changed

- Depend on perimeterx-nginx-plugin v7.1.3

## [3.0.0] - 2021-02-22

### Fixes

- Support for Kong 1.x and 2.x

## [2.0.1] - 2019-03-31

### Fixes

- Removed validation for custom_block_url and whitelist_uri_full

## [2.0.0] - 2019-01-07

Added:

- Captcha v2
- Sending cookie names on risk_api calls
- Added PXHD handling
- Various bug fixes

Breaking Changes:

- Custom captcha page has to work with captcha v2
- removed configurations: `captcha_provider`, `captcha_enabled`

## [1.4.0] - 2018-05-22

- Updated method of passing config to NGINX plugin

## [1.3.0] - 2018-02-19

- Update first party templates with fallback support
- Use relative URL for redirect in API protection mode

## [1.2.0] - 2018-01-31

- Support first party

## [1.1.0] - 2017-10-19

- API protection mode
