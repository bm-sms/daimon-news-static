# daimon-news-static

A news site generating tool.

## Installation

    $ git clone https://github.com/bm-sms/daimon-news-static.git
    $ cd daimon-news-static
    $ rake install

## Usage

    $ bin/run-api-mock &
    $ daimon-news-static-build NAME [options]

### Options

#### `--user-assets-dir`

default:

    $ daimon-news-static-build default
    ...
    $ ls default/stylesheets
    default.css

`--user-assets-dir` option is specified:

    $ ls source/
    stylesheets
    $ ls source/stylesheets
    user.css
    $ daimon-news-static-build custom --user-assets-dir=source
    ...
    $ ls custom/stylesheets
    user.css

Scaffold user assets dir (experimental):

    $ daimon-news-static-scaffold OUTPUT_PATH [SITE_NAME]

