# Go Build Finder
When compiling a Go program, you can specify the `GOOS` and `GOARCH`, but it isn't always obvious what you need to set for a particular environment. This utility is an attempt to help.

The heart of this is a small Go program that just prints a message to the console and adds a line to a `results.log` file. It has been compiled for multiple environments. Running the `run-tests.ps1` (Windows) or `run-tests.sh` (Linux) scripts will attempt to run each of the executables and show which ones have succeeded. Most will fail, so excpect to see a lot of errors, but hopefully at least one work! The list of successful ones will be displayed at the end and also recorded in a `results.log` file.

## Building
The `build.ps1` script will compile the Go program for every environment it can based on the output of `go tool dist list` and generates `run-tests.ps1` and `run-tests.sh`.
