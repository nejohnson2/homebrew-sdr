class Cmake < Formula  
  url "https://cmake.org/files/v3.3/cmake-3.3.2.tar.gz"
  sha256 "e75a178d6ebf182b048ebfe6e0657c49f0dc109779170bad7ffcb17463f2fc22"


  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --system-zlib
      --system-bzip2
      --no-system-curl
    ]

    system "./bootstrap", *args
    system "make"
    system "make", "install"
  end
end