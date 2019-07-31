const operatingSystem = require('../package.json')
const utils = require('./utils')

exports.singlePackage = function (packageName) {
  const package = require('../packages/' + packageName + '/package.json')

  utils.exec([
    'mkdir -p /build/tmp/work/' + package.name,
    'export OS_NAME=' + operatingSystem.name,
    'export OS_PROP=' + operatingSystem.prop,
    'export OS_VERSION=' + operatingSystem.version,
    'export OS_HOMEPAGE=' + operatingSystem.homepage,
    'export OS_BUGS=' + operatingSystem.bugs.url,
    'export PACKAGE_NAME=' + package.name,
    'export PACKAGE_VERSION=' + package.version,
    'export PACKAGE_DIR=/build/packages/' + package.name,
    'export SOURCE_DIR=/build/tmp/source',
    'export WORK_DIR=/build/tmp/work/' + package.name,
    'export ROOTFS_DIR=/build/tmp/rootfs',
    'export CFLAGS="-O3 -fPIC"',
    'export CXXFLAGS="-O3 -fPIC"',
    'cd packages/' + package.name,
    'npm install',
    'npm run install'
  ])
}

exports.allPackages = function () {
  for (const packageName of operatingSystem.systemDependencies) {
    exports.singlePackage(packageName)
  }
}
