#!/usr/bin/env node
const utils = require('./utils')
const build = require('./build')
const pack = require('./pack')

utils.createTmpDir()
build.allPackages()
pack.rootfs()
pack.iso()
