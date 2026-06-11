class RegistrationToolkit < Formula
  desc "C++ utilities for image-to-image and image-to-mesh registration"
  homepage "https://github.com/educelab/registration-toolkit"
  url "https://github.com/educelab/registration-toolkit/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e45e139d26b0f286e40af688f949337db8de4d44af6da3b6536a82ccf270994c"
  license "GPL-3.0-or-later"
  head "https://github.com/educelab/registration-toolkit.git", branch: "develop"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "itk"
  depends_on "opencv"
  depends_on "spdlog"
  depends_on "vtk"

  # Upstream's CMake uses FetchContent for these transitive deps, each pinned
  # to the commit/tag listed in cmake/Build*.cmake. Homebrew traps live
  # FetchContent calls, so we vendor them as resources and point the build at
  # the pre-staged sources via FETCHCONTENT_SOURCE_DIR_<NAME>.

  resource "smgl" do
    url "https://gitlab.com/educelab/smgl/-/archive/d74d76d121a18afab9b12dd9dc3d643f4e620ff1/smgl-d74d76d121a18afab9b12dd9dc3d643f4e620ff1.tar.gz"
    sha256 "527294f596b85f022d0e8e730924972b40cbca37412e3a9f702c920e55c27293"
  end

  resource "bvh" do
    url "https://github.com/madmann91/bvh/archive/66e445b92f68801a6dd8ef943fe3038976ecb4ff.tar.gz"
    sha256 "32f83c790d73ac0300059972f6e37e95506deb997479b956ecf1b4029e4e63c8"
  end

  resource "libcore" do
    url "https://github.com/educelab/libcore/archive/43666d4918a484e7e950fff7607865f78ff4b621.tar.gz"
    sha256 "c952c52396093c16790d5aa8ab0a07b895beff0b9339addecbb9b371f8b29304"
  end

  resource "OpenABF" do
    url "https://github.com/educelab/OpenABF/archive/3c1b52a02a15007d3dcb7746b08a4f3db0e7a0b6.tar.gz"
    sha256 "3ee9d00b279707d742991554b33e0029ca8c00b2a756a3df5de93825a526f4aa"
  end

  def install
    resource("smgl").stage(buildpath/"_deps/smgl")
    resource("bvh").stage(buildpath/"_deps/bvh")
    resource("libcore").stage(buildpath/"_deps/libcore")
    resource("OpenABF").stage(buildpath/"_deps/OpenABF")

    system "cmake", "-S", ".", "-B", "build",
                    "-DRT_BUILD_DOCS=OFF",
                    "-DRT_BUILD_TESTS=OFF",
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
                    "-DFETCHCONTENT_SOURCE_DIR_SMGL=#{buildpath}/_deps/smgl",
                    "-DFETCHCONTENT_SOURCE_DIR_BVH=#{buildpath}/_deps/bvh",
                    "-DFETCHCONTENT_SOURCE_DIR_LIBCORE=#{buildpath}/_deps/libcore",
                    "-DFETCHCONTENT_SOURCE_DIR_OPENABF=#{buildpath}/_deps/OpenABF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/rt_register --help 2>&1", 1)
  end
end
