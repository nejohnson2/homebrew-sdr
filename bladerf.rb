require 'formula'

class Bladerf < Formula
  homepage 'https://github.com/Nuand/bladeRF/wiki'
  head 'https://github.com/Nuand/bladeRF.git'

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    cd 'host/utilities/bladeRF-cli/src/cmd/doc' do
      system 'cp', 'cmd_help.h.in', 'cmd_help.h'
    end
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args
      system 'make'
      system 'make install'
    end
  end
end
