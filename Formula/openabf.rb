class Openabf < Formula
  desc "Single-header C++ library of angle-based flattening algorithms"
  homepage "https://github.com/educelab/OpenABF"
  url "https://github.com/educelab/OpenABF/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5f0628183235e56c2fdd29eeb342dfa2cfbfc86d4360c7c0aaae605a0349ee2a"
  license "Apache-2.0"
  head "https://github.com/educelab/OpenABF.git", branch: "develop"

  depends_on "cmake" => [:build, :test]
  depends_on "eigen" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build/"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <OpenABF/OpenABF.hpp>
      #include <cmath>

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
