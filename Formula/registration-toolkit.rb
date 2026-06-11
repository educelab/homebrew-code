class RegistrationToolkit < Formula
  desc "C++ utilities for image-to-image and image-to-mesh registration"
  homepage "https://github.com/educelab/registration-toolkit"
  url "https://github.com/educelab/registration-toolkit/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e45e139d26b0f286e40af688f949337db8de4d44af6da3b6536a82ccf270994c"
  license "GPL-3.0-or-later"
  head "https://github.com/educelab/registration-toolkit.git", branch: "develop"

  # Upstream uses CMake FetchContent for smgl, bvh, libcore, and OpenABF,
  # each pinned to an immutable commit/tag.
  allow_network_access! :build

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
