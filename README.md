Moon Logfmt
===========
[![Build Status](https://travis-ci.org/polyfox/moon-logfmt.svg?branch=master)](https://travis-ci.org/polyfox/moon-logfmt)
[![Test Coverage](https://codeclimate.com/github/polyfox/moon-logfmt/badges/coverage.svg)](https://codeclimate.com/github/polyfox/moon-logfmt)
[![Inline docs](http://inch-ci.org/github/polyfox/moon-logfmt.svg?branch=master)](http://inch-ci.org/github/polyfox/moon-logfmt)
[![Code Climate](https://codeclimate.com/github/polyfox/moon-logfmt/badges/gpa.svg)](https://codeclimate.com/github/polyfox/moon-logfmt)


Usage:
```ruby
logger = Moon::Logfmt::Logger.new
logger.io = STDERR
logger.write msg: 'World domination!', reason: 'Cookies' 
```
