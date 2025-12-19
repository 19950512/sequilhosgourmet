# Start watcher in a new window and run PHP built-in server in this console
param(
    [string]$ServerHost = 'localhost',
    [int]$Port = 3000
)

$watcher = Start-Process -FilePath "node" -ArgumentList "./scripts/build-css.js --watch" -WindowStyle Normal -PassThru
Write-Host "Started CSS watcher (PID: $($watcher.Id))"

try {
    Write-Host "Starting PHP dev server on http://${ServerHost}:${Port} ..."
    & php -S "${ServerHost}:${Port}" -t site
} finally {
    if ($watcher -and -not $watcher.HasExited) {
        Write-Host "Stopping watcher (PID: $($watcher.Id))..."
        $watcher.Kill()
    }
}
