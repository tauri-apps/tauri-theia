#!/usr/bin/env pwsh

# Cature Arguments
$mode = $args[0]
$path = $args[1]

# Names of the associated processes
$wwa_host = "WWAHost"
$webview_proc = "Win32WebViewHost"

# Get a list of process objects
$procs = Get-Process $wwa_host, $webview_proc | Format-List *

# allow loopback
CheckNetIsolation.exe LoopbackExempt -a -n="Microsoft.Win32WebViewHost_cw5n1h2txyewy"

# if mode is run
if ($mode -eq "run") {
    # start main process. 
    $main_proc = Start-Process -FilePath $path -PassThru -NoNewWindow -Wait
    # Wait for the process to exit before continuing. 
    $main_proc.WaitForExit()

    # Iterate through the process list. 
    foreach ($proc in $procs) {
        # shutdown each process. 
        Shutdown_Proc($name)
    }
    
    # Make sure that the main process has exited
    if (-Not $main_proc.HasExited) {
        Shutdown_Proc($main_proc)
    }

    # check that all processes have exited. 
    Get-Process | Where-Object { $_.HasExited }

    # kill this porcess. 
    Stop-process -Id $PID
}

# Simple function to shutdown processes without crashing the script
function Shutdown_Proc(
    [Object]$proc
) {
    Try {
        Stop-Process -InputObject $proc -Force
    }
    Catch [System.NullReferenceException] {
        Write-Output $_.Exception | Format-List -Force
    }
}