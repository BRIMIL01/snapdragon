require 'spec_helper'
require_relative '../../../lib/snapdragon/command_line_parser'

describe Snapdragon::CommandLineParser do
  describe "#parse" do
    subject { Snapdragon::CommandLineParser }
    
    it "display version information" do
      output = capture_stdout { subject.parse(["-v"]) }
      output.should match(/\d+\.\d+\.\d+/)
    end
    
    it "exit once version information is displayed" do
      lambda { hide_stdout { subject.parse(["-v"]) } }.should raise_error(SystemExit)
    end
    
    it "display usage information" do
      output = capture_stdout { subject.parse(["-h"]) }
      output.should match(/Usage/)
    end
    
    it "exit once usage information is displayed" do
      lambda { hide_stdout { subject.parse(["-h"]) } }.should raise_error(SystemExit)
    end
    
    context "no args supplied" do
      it "exit" do
        lambda { hide_stdout { subject.parse([]) } }.should raise_error(SystemExit)
      end
    end
    
    context "args supplied" do
      it "continue execution" do
        lambda { subject.parse(["spec/hello_spec.rb"]) }.should_not raise_error(SystemExit)
      end
    end

    context "when format is provided" do
      it "sets the format value" do
        subject.parse(["--format", "junit", "spec/hello_spec.rb"]).format.should eq "junit"
      end
    end

    context "when format is not provided" do
      it "defaults to console" do
        subject.parse(["spec/hello_spec.rb"]).format.should eq "console"
      end
    end
  end
end
