# Tauri Theia

[Theia IDE](https://theia-ide.org/) packaged as a Tauri application.

## To Use

Currently only working in Linux

1. Clone this repository and open a terminal in the root of it. Make sure to use Node v10.x
2. Install deps with `yarn`
3. Package Theia server as an executable with `yarn theia:package`
4. Copy the executable in `node_modules/vscode-ripgrep/bin/rg` to `src-tauri/theia-binaries/rg-x86_64-unknown-linux-gnu`
5. Run `yarn tauri build` to build the executable (read note below)

**NOTE:** Building the app will fail the first time. To fix this, you will need to rename the binary in `src-tauri/theia-binaries/theia` to the path in the error message from `yarn tauri build`.
