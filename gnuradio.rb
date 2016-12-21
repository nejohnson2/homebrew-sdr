class Gnuradio < Formula
  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "https://gnuradio.squarespace.com/"
  url "https://gnuradio.org/releases/gnuradio/gnuradio-3.7.9.1.tar.gz"
  sha256 "9c06f0f1ec14113203e0486fd526dd46ecef216dfe42f12d78d9b781b1ef967e"
  head 'git://gnuradio.org/gnuradio/gnuradio.git'

  depends_on 'cmake' => :build
  depends_on 'scipy' => :python
  depends_on 'boost'
  depends_on 'fftw'
  depends_on 'pygtk'
  depends_on 'swig'
  depends_on 'cppunit'
  depends_on 'pyqt'
  depends_on 'pyqwt'

  def options
    [
      ['--with-qt', 'Build gr-qtgui.'],
    ]
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    mkdir 'build' do
      args = ["-DCMAKE_PREFIX_PATH=#{prefix}", "-DQWT_INCLUDE_DIRS=#{HOMEBREW_PREFIX}/lib/qwt.framework/Headers", "-DQWT_LIBRARIES=#{HOMEBREW_PREFIX}/lib/qwt.framework/qwt", ] + std_cmake_args
      args << '-DENABLE_GR_QTGUI=OFF' unless ARGV.include?('--with-qt')

      python_prefix = `python-config --prefix`.strip

      args << '-DENABLE_DOXYGEN=OFF'
      args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
      args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
      args << "-DPYTHON_PACKAGES_PATH='#{lib}/#{which_python}/site-packages'"
      
      system 'cmake', '..', *args
      system 'make'
      system 'make install'
    end
  end

  def python_path
    python = Formula.factory('python')
    kegs = python.rack.children.reject { |p| p.basename.to_s == '.DS_Store' }
    kegs.find { |p| Keg.new(p).linked? } || kegs.last
  end

  def caveats
    <<-EOS.undent
    If you want to use custom blocks, create this file:
    ~/.gnuradio/config.conf
      [grc]
      local_blocks_path=/usr/local/share/gnuradio/grc/blocks
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
