/**
 * This script is used to copy the vscode-ripgrep binary and rename the Theia binary with the platform specific suffix.
 * When `tauri build` is ran, it looks for the binary name appended with the platform specific suffix.
 */

const execa = require('execa')
const fs = require('fs')
const isWin = process.platform === 'win32'
const winSuffix = isWin ? '.exe' : ''

async function main() {
  const rustTargetInfo = JSON.parse(
    (
      await execa(
        'rustc',
        ['-Z', 'unstable-options', '--print', 'target-spec-json'],
        {
          env: {
            RUSTC_BOOTSTRAP: 1
          }
        }
      )
    ).stdout
  )
  const platformSuffix = rustTargetInfo['llvm-target']
  fs.copyFileSync(
    `node_modules/vscode-ripgrep/bin/rg${winSuffix}`,
    `src-tauri/theia-binaries/rg-${platformSuffix}${winSuffix}`
  )
  fs.renameSync(
    `src-tauri/theia-binaries/theia${winSuffix}`,
    `src-tauri/theia-binaries/theia-${platformSuffix}${winSuffix}`
  )
}

main().catch((e) => {
  throw e
})
