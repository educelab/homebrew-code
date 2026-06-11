class RegistrationToolkit < Formula
  desc "C++ utilities for image-to-image and image-to-mesh registration"
  homepage "https://github.com/educelab/registration-toolkit"
  url "https://github.com/educelab/registration-toolkit/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a0b47765243cb58689da102326484cf5893a862ce4703e84cdc952c0190d315d"
  license "GPL-3.0-or-later"
  head "https://github.com/educelab/registration-toolkit.git", branch: "develop"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "itk"
  depends_on "opencv"
  depends_on "spdlog"
  depends_on "vtk"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DRT_BUILD_DOCS=OFF",
                    "-DRT_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/rt_register --help 2>&1", 1)
  end
end
