# homebrew-sdr
This repository is a collection of **Homebrew** formulas and directions to install various SDR software components.  After much pain and suffering always trying to get thing installed properly I started using **Homebrew** which has really simplified the process.  Certainly each install will be different, but I hope this provides a good foundation to get up and running with your SDR.

Currently, there are formulas for:
  - Python
  - GNU Radio 3.7
  - rtlsdr
  - gr-osmosdr
  - GQRX 2.3.2

This installation works for MacOSX Yosemite 10.10.2 and assumes you've installed [Xcode 6.1](https://developer.apple.com/xcode/downloads/), Commandline Tools and [XQuartz](http://xquartz.macosforge.org/landing/)

### Install Homebrew

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Install Python

```shell
brew install python
pip install matplotlib numpy lxml cheetah     # dependencies of gnuradio
```

### Install GNU Radio

Installing GNU Radio usually takes about 25 mins.  The formula will make sure all dependencies are met.

```shell
brew tap nejohnson2/homebrew-sdr
brew install gnuradio --with-brewed-python
```
Restart the computer.

### Install GQRX

I'm using the RTLSDR dongle.  For other SDR devices, install the desired driver before installing ```gr-osmosdr``` and ```gqrx```. 

```shell
brew install rtlsdr gr-osmosdr gqrx --HEAD
brew linkapps gqrx    # symlink the .app file to /Applications 
```

### Thanks

Many thanks to [titanous](https://github.com/titanous/homebrew-gnuradio), [metacollin](https://github.com/metacollin/homebrew-gnuradio), [dholm](https://github.com/dholm/homebrew-sdr) and [chleggett](https://github.com/chleggett/homebrew-gqrx) from whom I compiled this code.

More to come...
