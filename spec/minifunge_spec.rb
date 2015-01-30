#! /usr/bin/env ruby

require 'rspec'
require_relative '../minifunge.rb'

RSpec.describe Minifunge do
  it "should end the program (@)" do
    m = Minifunge.new("@")
    m.run
    expect(m.ended?).to eq true
  end

  it "should push numbers into stack" do
    m = Minifunge.new("3456@")
    m.run_one_instruction
    expect(m.stack.last).to eq 3
    m.run_one_instruction
    expect(m.stack.last).to eq 4
    m.run_one_instruction
    expect(m.stack.last).to eq 5
    m.run_one_instruction
    expect(m.stack.last).to eq 6

  end

  it "should duplicate the top stack value with (:)" do
    m = Minifunge.new("3:@")
    m.run
    expect(m.stack.last).to eq 3
    expect(m.stack.length).to eq 2

    m = Minifunge.new("9:::@")
    m.run
    expect(m.stack.last).to eq 9
    expect(m.stack.length).to eq 4
  end

  it "should switch the top two stack values with (=)" do
    m = Minifunge.new("43=@")
    m.run
    expect(m.stack.last).to eq 4
    expect(m.stack.first).to eq 3
    expect(m.stack.length).to eq 2
  end

  it "should dump the top stack value with ($)" do
    m = Minifunge.new("43$$@")
    m.run_one_instruction
    m.run_one_instruction
    expect(m.stack.last).to eq 3
    m.run_one_instruction
    expect(m.stack.last).to eq 4
    m.run_one_instruction
    expect(m.stack.length).to eq 0
  end

  it "should work with + operand" do
    m = Minifunge.new("34+@")
    m.run
    expect(m.stack.last).to eq 7

    m = Minifunge.new("99+@")
    m.run
    expect(m.stack.last).to eq 18

    m = Minifunge.new("19+9+1+@")
    m.run
    expect(m.stack.last).to eq 20
  end
  it "should work with - operand" do
    m = Minifunge.new("34-@")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new("43-@")
    m.run
    expect(m.stack.last).to eq -1

    m = Minifunge.new("99-@")
    m.run
    expect(m.stack.last).to eq 0

    m = Minifunge.new("49-2-@")
    m.run
    expect(m.stack.last).to eq -3
  end

  it "should work with * operand" do
    m = Minifunge.new("34*@")
    m.run
    expect(m.stack.last).to eq 12

    m = Minifunge.new("22*2*@")
    m.run
    expect(m.stack.last).to eq 8

    m = Minifunge.new("99*@")
    m.run
    expect(m.stack.last).to eq 81

    m = Minifunge.new("49*2*@")
    m.run
    expect(m.stack.last).to eq 72
  end

  it "should work with / operand" do
    m = Minifunge.new("24/@")
    m.run
    expect(m.stack.last).to eq 2

    m = Minifunge.new("24/2/@")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new("28/@")
    m.run
    expect(m.stack.last).to eq 4

    m = Minifunge.new("39/@")
    m.run
    expect(m.stack.last).to eq 3
  end

  it "should work with % operand" do
    m = Minifunge.new("25%@")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new("89%@")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new("28%@")
    m.run
    expect(m.stack.last).to eq 0

    m = Minifunge.new("69%@")
    m.run
    expect(m.stack.last).to eq 3
  end

  it "should change directions" do
    m = Minifunge.new("v@<\n> ^")
    expect(m.direction).to eq ?>
    m.run_one_instruction
    expect(m.direction).to eq ?v
    m.run_one_instruction
    expect(m.direction).to eq ?>
    m.run_one_instruction
    m.run_one_instruction
    expect(m.direction).to eq ?^
    m.run_one_instruction
    expect(m.direction).to eq ?<
  end

  it "should not (!) value" do
    m = Minifunge.new("0!@")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new("1!@")
    m.run
    expect(m.stack.last).to eq 0

    m = Minifunge.new("9!@")
    m.run
    expect(m.stack.last).to eq 0
  end

  it "should work with greater than (`)" do
    m = Minifunge.new ("41`@")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new ("14`@")
    m.run
    expect(m.stack.last).to eq 0

    m = Minifunge.new ("72`@")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new ("27`@")
    m.run
    expect(m.stack.last).to eq 0
  end

  it "should work with horizontal if (_)" do
    m = Minifunge.new ("0_7@")
    m.run
    expect(m.stack.last).to eq 7

    m = Minifunge.new (%q{1#@X#9_})
    m.run
    expect(m.stack.last).to eq 9
  end

  it "should work with vertical if (|)" do
    m = Minifunge.new ("vX@\nXX7\n>0|\nXX9\nXX@")
    m.run
    expect(m.stack.last).to eq 9

    m = Minifunge.new ("vX@\nXX7\n>1|\nXX9\nXX@")
    m.run
    expect(m.stack.last).to eq 7
  end

  it "should interpret string mode (\") correctly" do
    m = Minifunge.new (%{"H"@})
    m.run
    expect(m.stack.last).to eq ?H.ord

    m = Minifunge.new (%{"Hello"@})
    m.run
    expect(m.stack.last).to eq ?o.ord
  end

  it "should interpret integer mode ([]) correctly" do
    m = Minifunge.new ("[123]@")
    m.run
    expect(m.stack.last).to eq 123

    m = Minifunge.new ("[2222]@")
    m.run
    expect(m.stack.last).to eq 2222
  end

  it "should add integer value from stack to output with (.)" do
    m = Minifunge.new("3.@")
    m.run
    expect(m.output).to eq 3.to_s

    m = Minifunge.new("44*.@")
    m.run
    expect(m.output).to eq 16.to_s

    m = Minifunge.new("1234....@")
    m.run
    expect(m.output).to eq 4321.to_s

    m = Minifunge.new(%{"A".@})
    m.run
    expect(m.output).to eq ?A.ord.to_s
  end

  it "should add character from stack to output with (,)" do
    m = Minifunge.new(%{34*1+5*,@})
    m.run
    expect(m.output).to eq ?A

    m = Minifunge.new(%{"A",@})
    m.run
    expect(m.output).to eq ?A
  end

  it "should get integer from input (&)" do
    m = Minifunge.new(%{&@}, "1")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new(%{&&&@}, "123")
    m.run_one_instruction
    expect(m.stack.last).to eq 1
    m.run_one_instruction
    expect(m.stack.last).to eq 2
    m.run_one_instruction
    expect(m.stack.last).to eq 3
    m.run
  end

  it "should get character from input (~)" do
    m = Minifunge.new(%{~@}, "A")
    m.run
    expect(m.stack.last).to eq ?A.ord
  end

  it "should push correct value to stack if input's length is 0 (;)" do
    m = Minifunge.new(%{;@}, "A")
    m.run
    expect(m.stack.last).to eq 0

    m = Minifunge.new(%{~;@}, "A")
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new(%{;@})
    m.run
    expect(m.stack.last).to eq 1
  end

  it "should push correct value to stack if stack's length is 0 (?)" do
    m = Minifunge.new(%{?@})
    m.run
    expect(m.stack.last).to eq 1

    m = Minifunge.new(%{1?@})
    m.run
    expect(m.stack.last).to eq 0
  end

  it "should produce Hello, World!" do
    m = Minifunge.new(%{0"!dlroW ,olleH">:#,_@})
    m.run
    expect(m.output).to eq "Hello, World!"
  end

  it "should repeat input to output" do
    m = Minifunge.new(%q{#@;_ #;~# ,# <}, "Testing Testing 123")
    m.run
    expect(m.output).to eq "Testing Testing 123"

    m = Minifunge.new(%q{#@;_ #;~# ,# <}, "What what in the butt?")
    m.run
    expect(m.output).to eq "What what in the butt?"
  end

  it "should repeat input to output backwards" do
    code = %{v >#@?_ #?,# <\n>#|;_ #;~# <}
    m = Minifunge.new(code, "Testing Testing 123")
    m.run
    expect(m.output).to eq "Testing Testing 123".reverse
  end
end