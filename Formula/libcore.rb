class Libcore < Formula
  desc "C++ library of types and utilities shared across EduceLab projects"
  homepage "https://github.com/educelab/libcore"
  url "https://github.com/educelab/libcore/archive/refs/tags/v0.3.0-rc.2.tar.gz"
  sha256 "ba4aaa2921818529537e80b8b13296293d9916b9abfdf86e8454abab60eae233"
  license "GPL-3.0-or-later"
  head "https://github.com/educelab/libcore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/educelab/code"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12d7d7db6ee05be0f570ad974a0480a20417c603535a1e777a0acee0c7d9f261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040e1a0d8887270d6b9f66c9426f5f7eecb2a08ed97b691fd29b916a5259842c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "399df0b6387ef5832c39ffe939ed699171b08d36b82aecdf85dcd70ba02c0588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e1cfdd51090bb5e70e5e4826b0f044678e28cbe6070e8fcf921a6482362dcd"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DEDUCE_CORE_BUILD_DOCS=OFF",
                    "-DEDUCE_CORE_BUILD_EXAMPLES=OFF",
                    "-DEDUCE_CORE_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <educelab/core/Version.hpp>
      #include <educelab/core/types/Vec.hpp>
      #include <iostream>

      using namespace educelab;

      auto main() -> int {
        Vec3f a{1, 0, 0};
        Vec3f b{0, 1, 0};
        auto c = a.cross(b);
        if (c[0] != 0 || c[1] != 0 || c[2] != 1) {
          return 1;
        }
        std::cout << core::ProjectInfo::NameAndVersion() << std::endl;
        return 0;
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.15)
      project(test CXX)
      find_package(EduceLabCore REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test educelab::core)
    EOS
    system "cmake", "-S", testpath, "-B", "build",
                    "-DCMAKE_PREFIX_PATH=#{prefix}"
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
