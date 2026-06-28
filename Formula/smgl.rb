class Smgl < Formula
  desc "Structured Metadata Engine and Graph Object Library"
  homepage "https://github.com/educelab/smgl"
  url "https://github.com/educelab/smgl/archive/refs/tags/v0.11.0-rc.1.tar.gz"
  sha256 "dd4fd856d74ae607da4c9a0d1e7d420b3da7955dab8d0c8654218127b8b4150d"
  license "GPL-3.0-or-later"
  head "https://github.com/educelab/smgl.git", branch: "main"

  depends_on "cmake" => [:build, :test]
  depends_on "nlohmann-json"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSMGL_BUILD_DOCS=OFF",
                    "-DSMGL_BUILD_TESTS=OFF",
                    "-DSMGL_BUILD_JSON=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <smgl/Graph.hpp>

      auto main() -> int {
        smgl::Graph graph;
        return 0;
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.15)
      project(test CXX)
      find_package(smgl REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test smgl::smgl)
    EOS
    system "cmake", "-S", testpath, "-B", "build",
                    "-DCMAKE_PREFIX_PATH=#{prefix}"
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
