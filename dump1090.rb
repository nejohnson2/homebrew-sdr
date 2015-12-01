require 'formula'

class Dump1090 < Formula
  homepage 'https://github.com/MalcolmRobb/dump1090'
  head 'https://github.com/MalcolmRobb/dump1090.git'

  depends_on 'pkg-config' => :build
  depends_on 'libusb'
  depends_on 'librtlsdr'

  def install
    system 'make', "PREFIX=#{prefix}", "SHAREDIR=#{prefix}/public_html"
    bin.install "dump1090", "view1090"
    prefix.install "public_html"
  end
end
