class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.5.0.tar.gz"
  sha256 "0992af9e13bf756f0fb2abf08cd258631d08103cf833bb62936f09d2d5c60eb3"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90caf18e13c8636d27b332cb8acbe0944bb8effba7561ff193df37da22580135" => :sierra
    sha256 "8aa4850f497674190d6d374853519c1629e0fb2466c5618b1473ba47d172b697" => :el_capitan
    sha256 "48e82ebddcbc0c4777469014f69a1cc98f7263105aa4b17bcfb752ab11d37690" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.1-beta.0.tar.gz"
    sha256 "98582a12d32552694c4974a018b97c9d2e8c072befa5ab464d1d43fd35500b0d"
    version "1.5.1-beta.0"
  end

  depends_on "go" => :build

  def install
    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
