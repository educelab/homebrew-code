class Openabf < Formula
  desc "Single-header C++ library of angle-based flattening algorithms"
  homepage "https://github.com/educelab/OpenABF"
  url "https://github.com/educelab/OpenABF/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "46face5b5183745aa5adf1d24b4229244ef84a418b0afa788a884e3155a0f555"
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

      using ABF = OpenABF::ABFPlusPlus<float>;
      using LSCM = OpenABF::AngleBasedLSCM<float, ABF::Mesh>;
      auto main() -> int {
        // Make a triangular pyramid mesh
        auto mesh = ABF::Mesh::New();
        mesh->insert_vertex(0, 0, 0);
        mesh->insert_vertex(2, 0, 0);
        mesh->insert_vertex(1, std::sqrt(3), 0);
        mesh->insert_vertex(1, std::sqrt(3) / 3, 1);
        mesh->insert_face(0, 3, 1);
        mesh->insert_face(0, 2, 3);
        mesh->insert_face(2, 1, 3);
        ABF::Compute(mesh);
        LSCM::Compute(mesh);
      }
    EOS
    system ENV.cxx, "test.cpp",
      "-I#{include}",
      "-I#{HOMEBREW_PREFIX}/opt/eigen/include/eigen3/",
      "-DNDEBUG", "-O3",
      "-std=c++14",
      "-o", "test"
    system "./test"
  end
end
