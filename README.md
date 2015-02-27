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
pip install Pillow    # required for running the heatmap.py script
```

### Install GNU Radio

Installing GNU Radio usually takes about 25 mins.  The formula will make sure all dependencies are met.

```shell
brew tap nejohnson2/homebrew-sdr
brew install gnuradio --with-brewed-python
```
Restart the computer.

### Install GQRX

I'm using the RTLSDR dongle.  For other SDR devices, install the desired driver before installing ```gr-osmosdr``` and ```gqrx```.  Check [this page](http://sdr.osmocom.org/trac/wiki/GrOsmoSDR) for more information. 

```shell
brew install rtlsdr gr-osmosdr gqrx --HEAD
brew linkapps gqrx    # symlink the .app file to /Applications 
```

### SDR Testing

#### GQRX
Navigate to the Applications folder and launch GQRX.  The application should launch and you should be able to see click the power button on the top left side of the interface to start.  Then begin playing with all of the buttons.

#### RTL_Power
After installing the rtlsdr library, there are several python scripts that you can begin to use.  The easiest one to use is the ```rtl_power``` located in ```/usr/local/bin```.  [This blog](http://kmkeen.com/rtl-power/) give a good overview of specifics.  Here is an example:

```shell
rtl_power -f 90M:120M:8k -g 50 -i 2 -e 1h data.csv
```

The ```-f``` command specifies a range of frequencies to scan.  ```-i``` sets the speed in seconds.  ```-e``` sets the run time(though you can always use ```ctl-c``` to exit.  And then give a file to save data to.

After recording data, use the ```heatmap.py``` file to generate an high resolution image of the spectrum.  It looks something like this:

```shell
python heatmap.py input.csv output_file.png
```

### Thanks

Many thanks to [titanous](https://github.com/titanous/homebrew-gnuradio), [metacollin](https://github.com/metacollin/homebrew-gnuradio), [dholm](https://github.com/dholm/homebrew-sdr),[keenerd](https://github.com/keenerd/rtl-sdr-misc/tree/master/heatmap) and [chleggett](https://github.com/chleggett/homebrew-gqrx) from whom I compiled this code.

More to come...
