# docker-xmr-stak-amd-vega

Docker containers for [xmr-stak](https://github.com/fireice-uk/xmr-stak) with AMD RX Vegas on Linux, including donate level patch.

## Requirements

 * [docker](https://docs.docker.com/install/)

### The matching drivers on your host (choose one)

 * [AMDGPU-Unified Linux drivers 18.10](https://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-for-Linux-Release-Notes.aspx)

On you host, install the drivers with a command similar to (read the Dockerfile for the version of drivers you want to use):

#### Host Driver Installation

Below are examples of flags used when installing drivers on your host system to work with these docker containers.

##### 18.10

```
./amdgpu-pro-18.10-572953/amdgpu-pro-install -y --opencl=pal
```

## Usage

### First

Pull the latest build with the driver tag that you've installed on your host (example):

```
docker pull bananajamma/xmr-stak-amd-vega:latest
```

### Running

Example:

```
docker run --device /dev/dri --device /dev/kfd --group-add=video -it --rm --name xmr-stak bananajamma/xmr-stak-amd-vega:latest -o communitypool.stellite.cash:6699 -u Se3ErfxDaYmCpdJQKrQVaCS5V9dLrczKoi4yYuRN7YssgyiiBGajKddLq8NwEwCuGkLikaP8akD1eZHoYwAvFP1A1S6r3eXKG -p x --currency cryptonight_v7_stellite --noCPU
```

### Building

If you've clone this repo and made changes:

```
docker build . --tag bananajamma/xmr-stak-amd-vega:latest
```

## FAQ

#### Does this work with more than one Vega?

I don't know, I only have one Vega right now.  I think it requires PCIe x16, and a [ROCm capable CPU](https://github.com/RadeonOpenCompute/ROCm#supported-cpus).  Let me know.

## License

MIT
