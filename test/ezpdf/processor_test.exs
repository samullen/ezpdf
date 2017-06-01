defmodule ProcessorTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import EZPDF.Processor, only: [
    process_markdown: 1,
    process_pdf: 1,
    output_pdf: 1
  ]

  describe "process_markdown/1" do
    test "it takes STDIN if no input file is provided" do
      assert process_markdown(["./test/fixtures/files/input.md"]) == {:ok, "<h1>Hello, World!</h1>\n", []} 
    end

    test "it reads data from a provided input file" do
      capture_io("# Hello, World!", fn -> 
        send self(), process_markdown([])
      end) 
      assert_received {:ok, "<h1>Hello, World!</h1>\n", []} 
    end
  end

  describe "process_pdf/1" do
    test "it takes a tuple with HTML, and returns PDF output" do
      true
      # assert process_pdf({:ok, "<h1>Hello, World!</h1>\n", []}) == "something"
    end
  end

  describe "output_pdf/1" do
    test "it writes the PDF output to the path specified in output" do
      Application.put_env(:ezpdf, "output", "/tmp/ezpdf.pdf")
      output_pdf({:ok, "not a pdf"})
      assert File.read("/tmp/ezpdf.pdf") == {:ok, "not a pdf"}
      Application.delete_env(:ezpdf, "output")
    end
    
    test "it writes the PDF to output.pdf" do
      output_pdf({:ok, "not a pdf"})
      assert File.read(Path.expand("output.pdf")) == {:ok, "not a pdf"}
      File.rm(Path.expand("output.pdf"))
    end
  end
end

