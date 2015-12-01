require "formula"

class Libosmocore < Formula
  homepage "http://bb.osmocom.org/trac/wiki/libosmocore"
  head "https://github.com/nejohnson2/libosmocore.git"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "pcsc-lite"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
