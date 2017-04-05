## phpcpd - Copy/Paste Detector (CPD) for PHP code
[![Docker Pulls](https://img.shields.io/docker/pulls/rvannauker/phpcpd.svg)](https://hub.docker.com/r/rvannauker/phpcpd/) [![Docker Stars](https://img.shields.io/docker/stars/rvannauker/phpcpd.svg)](https://hub.docker.com/r/rvannauker/phpcpd/) [![](https://images.microbadger.com/badges/image/rvannauker/phpcpd:latest.svg)](https://microbadger.com/images/rvannauker/phpcpd:latest) [![GitHub issues](https://img.shields.io/github/issues/RichVRed/docker-phpcpd.svg)](https://github.com/RichVRed/docker-phpcpd) [![license](https://img.shields.io/github/license/RichVRed/docker-phpcpd.svg)](https://tldrlegal.com/license/mit-license)

Docker container to install and run phpcpd

### Installation / Usage
1. Install the rvannauker/phpcpd container:
```bash
docker pull rvannauker/phpcpd
```
2. Run phpcpd through the phpcpd container:
```bash
sudo docker run --rm --volume $(pwd):/workspace --name="phpcpd" "rvannauker/phpcpd" {destination}
```

### Download the source:
To run, test and develop the PHPCPD Dockerfile itself, you must use the source directly:
1. Download the source:
```bash
git clone https://github.com/RichVRed/docker-phpcpd.git
```
2. Build the container:
```bash
sudo docker build --force-rm --tag "rvannauker/phpcpd" --file phpcpd.dockerfile .
```
3. Test running the container:
```bash
 $ docker run rvannauker/phpcpd --help
```