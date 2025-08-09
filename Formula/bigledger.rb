class Bigledger < Formula
  desc "BigLedger CLI - Unified command-line interface for BigLedger operations"
  homepage "https://github.com/bigledger/blg-bigledger-cli"
  version "1.1.0"
  
  # Using JAR distribution from S3 (public access)
  # The main repository is PRIVATE, so we use S3 for public distribution
  url "https://public.aimatrix.com/bigledger/v1.1.0/blg-bigledger-cli-1.1.0.jar"
  sha256 "7a41420a1432176461a48cdf2b5a9e21406e66074dc2f9a3f10259c40a750da5"
  
  depends_on "openjdk@17"
  
  def install
    libexec.install "blg-bigledger-cli-#{version}.jar"
    
    # Create wrapper script
    (bin/"bigledger").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk@17"].opt_bin}/java" -jar "#{libexec}/blg-bigledger-cli-#{version}.jar" "$@"
    EOS
    
    chmod 0755, bin/"bigledger"
  end
  
  test do
    output = shell_output("#{bin}/bigledger --version")
    assert_match version.to_s, output
  end
  
  def caveats
    <<~EOS
      BigLedger CLI v#{version} has been installed!
      
      New in v1.1.0:
      • Doctor command for system diagnostics
      • Workspace folder management (BLG_WORKSPACE_FOLDER)
      • Default workspace at ~/blg-workspace
      
      Quick start:
        bigledger --version       # Check version
        bigledger doctor          # Run system diagnostics
        bigledger chat            # Interactive AI chat mode
        bigledger gh projects export --output report.xlsx
      
      Set workspace folder:
        export BLG_WORKSPACE_FOLDER=/path/to/workspace
      
      For help:
        bigledger --help
    EOS
  end
end