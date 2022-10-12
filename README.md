# UTM Auto-Installer

**UTM Auto-Installer** is a shell script that allows users to automate deploying lab environments at scale.

## Installation

Download the latest flightsim binary for your OS from the [GitHub Releases](https://github.com/alphasoc/flightsim/releases) page. Alternatively, the utility can be built using [Golang](https://golang.org/doc/install) in any environment (e.g. Linux, MacOS, Windows), as follows:

```
go get -u github.com/alphasoc/flightsim/...
```

## Running Network Flight Simulator

Upon installation, test flightsim as follows:

```
$ flightsim --help

AlphaSOC Network Flight Simulator™ (https://github.com/alphasoc/flightsim)

flightsim is an application which generates malicious network traffic for security
teams to evaluate security controls (e.g. firewalls) and ensure that monitoring tools
are able to detect malicious traffic.

Usage:
    flightsim <command> [arguments]

Available commands:
    get         Get a list of elements (ie. families) of a certain category (ie. c2)
    run         Run all modules, or a particular module
    version     Prints the version number

Cheatsheet:
    flightsim run                   Run all the modules
    flightsim run c2                Simulate C2 traffic
    flightsim run c2:trickbot       Simulate C2 traffic for the TrickBot family
    flightsim run ssh-transfer:1GB  Simulate a 1GB SSH/SFTP file transfer

    flightsim get families:c2       Get a list of all c2 families
```

The utility runs individual modules to generate malicious traffic. To perform all available tests, simply use `flightsim run` which will generate traffic using the first available non-loopback network interface. **Note:** when running many modules, flightsim will gather destination addresses from the AlphaSOC API, so requires egress Internet access.

To list the available modules, use `flightsim run --help`. To execute a particular test, use `flightsim run <module>`, as below.









## Description of Modules

The modules packaged with the utility are listed in the table below.

| Module        | Description                                                                   |
| ------------- | ----------------------------------------------------------------------------- |
| `c2`          | Generates both DNS and IP traffic to a random list of known C2 destinations   |
| `dga`         | Simulates DGA traffic using random labels and top-level domains               |
| `imposter`    | Generates DNS traffic to a list of imposter domains                           |
| `miner`       | Generates Stratum mining protocol traffic to known cryptomining pools         |
| `scan`        | Performs a port scan of random RFC 5737 addresses using common TCP ports      |
| `sink`        | Connects to known sinkholed destinations run by security researchers          |
| `spambot`     | Resolves and connects to random Internet SMTP servers to simulate a spam bot  |
| `ssh-exfil`   | Simulates an SSH file transfer to a service running on a non-standard SSH port|
| `ssh-transfer`| Simulates an SSH file transfer to a service running on an SSH port            |
| `tunnel-dns`  | Generates DNS tunneling requests to \*.sandbox.alphasoc.xyz                   |
| `tunnel-icmp` | Generates ICMP tunneling traffic to an Internet service operated by AlphaSOC  |
