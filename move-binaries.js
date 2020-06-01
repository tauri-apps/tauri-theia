/**
 * This script is used to copy the vscode-ripgrep binary and rename the Theia binary with the platform specific postfix.
 * When `tauri build` is ran, it looks for the binary name appended with the platform specific postfix.
 */

const execa = require('execa')
const fs = require('fs')

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
  const platformPostfix = rustTargetInfo['llvm-target']
  fs.copyFileSync(
    'node_modules/vscode-ripgrep/bin/rg',
    `src-tauri/theia-binaries/rg-${platformPostfix}`
  )
  fs.renameSync(
    'src-tauri/theia-binaries/theia',
    `src-tauri/theia-binaries/theia-${platformPostfix}`
  )
}

main().catch((e) => {
  throw e
})
