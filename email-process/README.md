# Commands to be set into aliases

## Overview

* each script has its own working name, used for identification of each script
* script will be used as symlink, its name is used for config name to run (without `.py` if symlink has)
* config.json has all for one site, identified by `script working name`-`config name`
* for GitHub integration, use PAT, each shall be limited to dedicated repository with minimum permission

## Scripts

### email-issue

Config: `target` for target GitHub repository, `key` as PAT with issue read/write

Open new issue to configured target repository using PAT token.
Add line to `aliases` as `| <script_name>`, with making symlink as configuration name.

Subject will be used for title of issue, text (text/plain part) will be used for description, with From: and Date:.
