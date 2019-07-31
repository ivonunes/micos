const execSync = require('child_process').execSync

exports.exec = function (commands) {
  execSync(
    commands.join(' && '),
    { stdio: 'inherit' }
  )
}

exports.createTmpDir = function () {
  exports.exec([
    'mkdir -p tmp/source',
    'mkdir -p tmp/work',
    'mkdir -p tmp/rootfs'
  ])
}
