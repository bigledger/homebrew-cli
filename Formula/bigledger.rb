class Bigledger < Formula
  desc "BigLedger CLI - Unified command-line interface for BigLedger operations"
  homepage "https://github.com/bigledger/blg-bigledger-cli"
  version "1.1.1"
  
  # Using JAR distribution from S3 (public access)
  # The main repository is PRIVATE, so we use S3 for public distribution
  url "https://public.aimatrix.com/bigledger/v1.1.1/blg-bigledger-cli-1.1.1.jar"
  sha256 "84f6ef0c693b030c4c2db498a551f876b2a61f8a16f1210b0e394f0b5403859f"
  
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
      
      New in v1.1.1:
      • Fixed "No line found" error in chat mode
      • Improved input handling and error recovery
      • Case-insensitive commands (/HELP now works)
      • All edge cases handled gracefully
      
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