class Bigledger < Formula
  desc "BigLedger CLI - Unified command-line interface for BigLedger operations"
  homepage "https://github.com/bigledger/blg-bigledger-cli"
  version "1.1.2"
  
  # Using JAR distribution from S3 (public access)
  # The main repository is PRIVATE, so we use S3 for public distribution
  url "https://public.aimatrix.com/bigledger/v1.1.2/blg-bigledger-cli-1.1.2.jar"
  sha256 "b20d2d503eb21ce1d6a9d00b78a31e0829fcfa8c9d0541835f14c372fa86949b"
  
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
      
      New in v1.1.2:
      • CRITICAL FIX: Chat mode now waits for user input properly
      • Fixed immediate exit bug in interactive terminals
      • Removed incorrect hasNextLine() checks
      • Proper exception handling for input streams
      
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