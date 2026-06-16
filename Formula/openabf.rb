class Openabf < Formula
  desc "Single-header C++ library of angle-based flattening algorithms"
  homepage "https://github.com/educelab/OpenABF"
  url "https://github.com/educelab/OpenABF/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "202a7cc14c8be612ae2b5c2c18dbf3af348e1bdc3844e823a280bdab320c863f"
  license "Apache-2.0"
  head "https://github.com/educelab/OpenABF.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/educelab/code"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45bdc5952397540e69122fd54fed71c5e1a41d887f46f2a5993ce37c5ef11cff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56d19babb2d78bbb569a5daead065578416e9071e7d2720f9f72c0736f2ceb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c16635da4b1bc12520281c86c058d1df68c5ea5c00a7030d09c5ae438357dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d3dc87d710d26f00ac2efe522716ebe5bd2ebc090d62a107979e732246535b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build/"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <OpenABF/OpenABF.hpp>

      using ABF = OpenABF::ABFPlusPlus<float>;
      using LSCM = OpenABF::AngleBasedLSCM<float, ABF::Mesh>;
      auto main() -> int {
        // Make a triangular pyramid mesh
        auto mesh = ABF::Mesh::New();
        mesh->insert_vertex(0, 0, 0);
        mesh->insert_vertex(2, 0, 0);
        mesh->insert_vertex(1, std::sqrt(3.f), 0);
        mesh->insert_vertex(1, std::sqrt(3.f) / 3, 1);
        // insert_faces() adds faces and calls update_boundary() automatically (v2.0.0+)
        mesh->insert_faces({{0, 3, 1}, {0, 2, 3}, {2, 1, 3}});
        ABF::Compute(mesh);
        LSCM::Compute(mesh);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp",
      "-I#{include}",
      "-I#{HOMEBREW_PREFIX}/opt/eigen/include/eigen3/",
      "-DNDEBUG", "-O3",
      "-std=c++17",
      "-o", "test"
    system "./test"
  end
end
