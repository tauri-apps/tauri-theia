#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

use std::{
  io::{BufRead, BufReader},
  process::{Command, Stdio},
};
use tauri::Handle;
mod cmd;

fn main() {
  tauri::AppBuilder::new()
    .setup(|_webview, _| {
      let handle_clone = _webview.handle().clone();
      std::thread::spawn(move || {
        spawn_theia_server(&handle_clone);
      });
      // .join().unwrap();
    })
    .build()
    .run();
}

fn spawn_theia_server<T: 'static>(handle: &Handle<T>) {
  let binary_name = tauri::api::command::binary_command("theia".to_string()).unwrap();
  let binary_path = tauri::api::command::relative_command(binary_name).unwrap();
  let stdout = Command::new(binary_path)
    // It doesn't source plugins from inside the pkg binary for some reason, so this doesn't work
    // .args(&["--plugins=local-dir:plugins"])
    .stdout(Stdio::piped())
    .spawn()
    .expect("Failed to start theia server")
    .stdout
    .expect("Failed to get theia server stdout");
  let reader = BufReader::new(stdout);
  let mut webview_started = false;
  reader
    .lines()
    .filter_map(|line| line.ok())
    .for_each(|line| {
      if line.starts_with("root INFO Theia app listening on ") {
        let url = line.chars().skip(33).collect::<String>().replace(".", "");
        if !webview_started {
          webview_started = true;
          handle
            .dispatch(move |webview| webview.eval(&format!("window.location.replace('{}')", url)))
            .expect("failed to initialize app");
        }
      }
    });
}
