class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.36/gsettings-desktop-schemas-3.36.1.tar.xz"
  sha256 "004bdbe43cf8290f2de7d8537e14d8957610ca479a4fa368e34dbd03f03ec9d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aa8dd0116bae54cedb04a0fd4ac6e3fe69064b9ee6caf55d7b3b730781d1037" => :catalina
    sha256 "9aa8dd0116bae54cedb04a0fd4ac6e3fe69064b9ee6caf55d7b3b730781d1037" => :mojave
    sha256 "9aa8dd0116bae54cedb04a0fd4ac6e3fe69064b9ee6caf55d7b3b730781d1037" => :high_sierra
    sha256 "02c38afc4db12f28684e726d5fe69f6864580840860c699178d8682d25e88d1d" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "glib"

  uses_from_macos "expat"

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
