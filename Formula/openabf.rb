class Openabf < Formula
  desc "Single-header C++ library of angle-based flattening algorithms"
  homepage "https://github.com/educelab/OpenABF"
  url "https://github.com/educelab/OpenABF/archive/refs/tags/v1.1.tar.gz"
  sha256 "5d99e1938352f8d1fd601eb11e5a43be8a68e4ca0662b01343b4b78a23a0dbbf"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "eigen" => :build

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
    system ENV.css, "test.cpp", "-I#{include}", "-std=c++14", "-o", "test"
    system "./test"
  end
end
