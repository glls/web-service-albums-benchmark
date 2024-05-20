# Benchmarking API Frameworks

## Project scope

Serve a list of 100 albums with a REST like interface (JSON) and measure the performance with [wrk](https://github.com/wg/wrk)

## Requirements

* server should run on port 8000
* server app should be optimized for speed (release mode) when possible
* output should be RAW JSON prepared in advance
* albums should be pre-loaded, no database or file access
* benchmark all apps on the same machine with minimum apps loaded
  * `wrk -d 20 -t 1 -c 1 http://127.0.0.1:8000/albums` (client with 1 thread and 1 connection)
  * `wrk -d 20 http://127.0.0.1:8000/albums`(client with 2 threads and 10 connections - default)
  * `wrk -d 20 -t 16 -c 500 http://127.0.0.1:8000/albums` (client with 16 threads and 500 connections)

## Benchmark machines

Machine #1 (Workstation)

* Gigabyte B660 GAMING X DDR4
* 12th Gen Intel® Core™ i9-12900K × 24
* Corsair 32,0 GiB DDR4/3200 RAM
* KIOXIA-EXCERIA SSD 1TB
* Ubuntu 24.04

Machine #2 (Server VM)

* MSI PRO H610M-E 
* 14th Gen Intel® Core™ i5-14600K x 20 -> 8 cores used
* 16 GiB DDR5 -> 8GB used
* UNRAID SSD 20GB
* Ubuntu 22.04.4 LTS Server

Extra information can be found in each mini project's folder.
![Chart](chart.svg)

You can also check my article [The correct way to benchmark your web server](https://georgelitos.com/post/benchmark-webserver/)
