#! /usr/bin/env ruby

require 'rspec'
require_relative '../minifunge.rb'

RSpec.describe Minifunge do
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
    
    m = Minifunge.new ("1#@X#9_")
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
  end
end