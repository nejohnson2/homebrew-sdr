class Pyqt4 < Formula
  desc ""
  homepage ""
  url "http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-4.11.4/PyQt-mac-gpl-4.11.4.tar.gz"
  version "4.11.4"
  sha256 "f178ba12a814191df8e9f87fb95c11084a0addc827604f1a18a82944225ed918"

  depends_on :python
  depends_on "sip" # if your formula requires any X11/XQuartz components

  def install
      Language::Python.each_python(build) do |python, version|
        args = ["--confirm-license",
                "--bindir=#{bin}",
                "--destdir=#{lib}/python#{version}/site-packages",
                "--stubsdir=#{lib}/python#{version}/site-packages/PyQt5",
                "--sipdir=#{share}/sip/Qt5",
                # sip.h could not be found automatically
                "--sip-incdir=#{Formula["sip"].opt_include}",
                # Make sure the qt5 version of qmake is found.
                # If qt4 is linked it will pickup that version otherwise.
                "--qmake=#{Formula["qt5"].bin}/qmake",
                # Force deployment target to avoid libc++ issues
                "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
                "--qml-plugindir=#{pkgshare}/plugins",
                "--verbose"]

        system python, "configure.py", *args
        system "make"
        system "make", "install" # if this fails, try separate make/make install steps
      end
  end
end
