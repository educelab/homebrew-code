class Openabf < Formula
  desc "Single-header C++ library of angle-based flattening algorithms"
  homepage "https://github.com/educelab/OpenABF"
  url "https://github.com/educelab/OpenABF/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "202a7cc14c8be612ae2b5c2c18dbf3af348e1bdc3844e823a280bdab320c863f"
  license "Apache-2.0"
  head "https://github.com/educelab/OpenABF.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/educelab/code"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "356983c2554220529c48531c3cb07604684f934deb41cc9142a9f302b32b03bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64af670046e3532d96433531995d67aefdc1130848d583fef595f8d8d164b214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad9dacdedfc545300d1f8d79cd203c14926d5f257c8b75605dcdd5a93b1d7230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f4bcf4cdf1b12f850c529124dc341db586ebe7626cee49972c506a46276061"
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
