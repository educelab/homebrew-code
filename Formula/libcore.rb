class Libcore < Formula
  desc "C++ library of types and utilities shared across EduceLab projects"
  homepage "https://github.com/educelab/libcore"
  url "https://github.com/educelab/libcore/archive/refs/tags/v0.3.0-rc.1.tar.gz"
  sha256 "a8b9a6625db695acad1a1a8779839152204edc70a9fd0074b1c5d04cf69d1a44"
  license "GPL-3.0-or-later"
  head "https://github.com/educelab/libcore.git", branch: "develop"

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
