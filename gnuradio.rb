require "formula"

class Gnuradio < Formula
  homepage "http://gnuradio.org"
  head "https://github.com/gnuradio/gnuradio.git"
  url "http://gnuradio.org/releases/gnuradio/gnuradio-3.7.5.1.tar.gz"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"

  option "without-qt", "Build with QT widgets in addition to wxWidgets"
  option "without-docs", "Build gnuradio documentation"
  option "with-brewed-python", "Use the Homebrew version of Python"

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.1.tar.gz"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end

  resource "numpy" do
    url "http://downloads.sourceforge.net/project/numpy/NumPy/1.9.1/numpy-1.9.1.tar.gz"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end

  resource "scipy" do
    url "http://downloads.sourceforge.net/project/scipy/scipy/0.14.0/scipy-0.14.0.tar.gz"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end

  if build.without? "brewed-python"
    resource "matplotlib" do
      url "https://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.4.2/matplotlib-1.4.2.tar.gz"
      sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
    end
  end

  depends_on :fortran => :build
  depends_on "cmake" => :build
  if build.with? "brewed-python"
    depends_on "matplotlib" => :python
  end
  depends_on "boost"
  depends_on "cppunit"
  depends_on "gsl"
  depends_on "fftw"
  depends_on "swig" => :build
  depends_on "pygtk"
  depends_on "sdl"
  depends_on "libusb"
  depends_on "orc"
  depends_on "pyqt" if build.with? "qt"
  depends_on "pyqwt" if build.with? "qt"
  depends_on 'sphinx' if build.with? "docs"
  depends_on "wxpython"
  depends_on "wxmac"
  depends_on "freetype"

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    python_args = ["install", "--prefix=#{libexec}"]
    %w[Cheetah lxml].each do |r|
      resource(r).stage { system "python", "setup.py", *python_args }
    end
    if build.without? "brewed-python"
      resource("matplotlib").stage do
        if MacOS.version >= :yosemite
          inreplace "setupext.py", "'freetype2', 'ft2build.h',", "'freetype2', 'freetype2/ft2build.h',"
        end
        system "python", "setup.py", *python_args
      end
    end
    python_fortran_args = ["build", "--fcompiler=gfortran", *python_args]
    %w[numpy scipy].each do |r|
      resource(r).stage { system "python", "setup.py", *python_fortran_args }
    end

    if build.with? "docs"
      resource("docutils").stage do
        system "python", "setup.py", "install", "--prefix=#{buildpath}"
      end
    end

    mkdir "build" do
      ENV["CMAKE_C_COMPILER"] = "#{ENV.cc}"
      ENV["CMAKE_CXX_COMPILER"] = "#{ENV.cxx}"

      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
        -DENABLE_DOXYGEN=Off
      ]
      if build.with? "brewed-python"
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      end

      if build.with? "docs"
        args << "-DSPHINX_EXECUTEABLE=#{buildpath}/bin/rst2html.py"
      else
        args << "-DENABLE_SPHINX=OFF"
      end

      if build.with? "qt"
        args << "-DENABLE_GR_QTGUI=ON"
      else
        args << "-DENABLE_GR_QTGUI=OFF"
      end

      system "cmake", "..", *args, *std_cmake_args
      system "make"
      system "make install"

      inreplace "#{prefix}/etc/gnuradio/conf.d/grc.conf" do |s|
        s.gsub! "#{prefix}/", "#{HOMEBREW_PREFIX}/"
      end
    end
  end
end
