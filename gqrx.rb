require 'formula'

class Gqrx < Formula
  homepage 'https://github.com/csete/gqrx'
  head 'https://github.com/csete/gqrx.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'qt'
  depends_on 'boost'
  depends_on 'gnuradio'
  depends_on 'gr-osmosdr'

  def install
    args = "PREFIX=#{prefix}"
    mkdir "build" do
      system "qmake",  *args, ".."
      system "make"
    end
    Dir.glob("build/*.app") { |app| mv app, prefix }
  end
end
