class Openabf < Formula
  desc "Single-header C++ library of angle-based flattening algorithms"
  homepage "https://github.com/educelab/OpenABF"
  url "https://github.com/educelab/OpenABF/archive/refs/tags/v2.1.0-rc.1.tar.gz"
  sha256 "1ee4c74b8ea49684213539a28c3336d643797ca5a5a768c28c9219ed1ad1c040"
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
