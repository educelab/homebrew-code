class Smgl < Formula
  desc "Structured Metadata Engine and Graph Object Library"
  homepage "https://github.com/educelab/smgl"
  url "https://github.com/educelab/smgl/archive/refs/tags/v0.11.0-rc.2.tar.gz"
  sha256 "716872dde791694cba4617c41b3d71050dfedbb500b2823581210ca805d49660"
  license "GPL-3.0-or-later"
  head "https://github.com/educelab/smgl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/educelab/code"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8436780a3c77a5e5a0533f51e9bc9443b424a703580479c879b3b1fcc5510045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "264e9e180008cb0b10cd0acbb9e4d40ec601155863c2a94da402845d5e5aa676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89356325bed77761e25f69c6c096b1af9a9f8d82178b2e82dfbb89ffef32be9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d80ecadd1c651f87d6ce601446420c124c096882d87908b235a6d94606404af"
  end

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
