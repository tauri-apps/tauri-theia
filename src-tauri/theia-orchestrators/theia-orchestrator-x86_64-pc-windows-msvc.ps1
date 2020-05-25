#!/usr/bin/env pwsh

# Cature Arguments
$mode = $args[0]
$path = $args[1]

# Names of the associated proceesses
$wwa_host = "WWAHost"
$webview_proc = "Win32WebViewHost"
$app_name = "theia-x68_64-pc-windows-msvc"

# allow loopback
CheckNetIsolation.exe LoopbackExempt -a -n="Microsoft.Win32WebViewHost_cw5n1h2txyewy"

# if mode is run
if ($mode -eq "run") {
    # start process on the inputted filepath. 
    Start-Process -FilePath $path -PassThru -NoNewWindow 

    # get the main process and wait until that process exits before execution. 
    $main_proc = Get-Process -Name $app_name -ErrorAction SilentlyContinue | Wait-Process 

    # stop the main process 
    Stop-Process -InputObject $main_proc

    # get the proccesses associated with the webview and wwa. 
    $wv_proc = Get-Process -Name $webview_proc
    $wwa_proc = Get-Process -Name $wwa_host

    # Kill WWA and Webview
    $wv_proc.Kill()
    $wwa_proc.Kill()

    # check that all processes associated with objects have exited. 
    Get-Process | Where-Object { $_.HasExited }
  
    # kill this porcess. 
    Stop-process -Id $PID
}