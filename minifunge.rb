#! /usr/bin/env ruby
DEBUG = false
class Minifunge
  DIRECTIONS = [?>, ?<, ?^, ?v]
  OPERANDS = [?+, ?-, ?*, ?/, ?%]
  INSTRUCTIONS = [?@, ?!, ?", ?`, ?_, ?_, ?:, ?=, ?$, ?., ?,, ?&, ?~, ?#] + DIRECTIONS + OPERANDS
  
  attr_reader :code, :input, :stack, :position, :direction, :output
  
  def initialize(code, input = "")
    @code = code.lines.map(&:chomp)
    @input = input
    @stack = []
    @position = Struct.new(:x, :y).new(0, 0)
    @direction = ?>
    @output = ""
  end
  
  def get_code
    @code[@position.y][@position.x]
  end
  
  def move(spaces)
    if @direction == ?>
      @position.x += spaces
    elsif @direction == ?<
      @position.x -= spaces
    elsif @direction == ?^
      @position.y -= spaces
    elsif @direction == ?v
      @position.y += spaces
    end
  end
  
  def run_one_instruction
    if DIRECTIONS.include? get_code
      @direction = get_code
    elsif OPERANDS.include? get_code
      a = @stack.pop
      b = @stack.pop
      @stack << a.send(get_code.to_sym, b)
    elsif get_code == ?!
      v = @stack.pop
      @stack << ((v == 0) ? 1 : 0)
    elsif get_code == ?`
      a = @stack.pop
      b = @stack.pop
      @stack << ((b > a) ? 1 : 0)
    elsif get_code == ?_
      @direction = ((@stack.pop == 0) ? ?> : ?<)
    elsif get_code == ?|
      @direction = ((@stack.pop == 0) ? ?v : ?^)
    elsif get_code == ?:
      @stack << @stack.last
    elsif get_code == ?=
      a = @stack.pop
      b = @stack.pop
      @stack << a
      @stack << b
    elsif get_code == ?$
      @stack.pop
    elsif get_code == ?.
      @output << @stack.pop.to_s
    elsif get_code == ?,
      @output << @stack.pop.chr
    elsif get_code == ?&
      @stack << @input.slice!(0).ord
    elsif get_code == ?~
      @stack << @input.slice!(0).ord
    elsif get_code == ?"
      loop do
        #move first
        move(1)     
        break if get_code == ?"
        @stack << get_code.ord
      end
    elsif (?0..?9).include? get_code
      @stack << get_code.to_i
    end

    move((get_code == ?#) ? 2 : 1)
    
    @output
  end
  
  def run
    until get_code == ?@
      run_one_instruction
    end
    @output
  end

  def run_from_beginning
    @input = input
    @stack = []
    @position = Struct.new(:x, :y).new(0, 0)
    @direction = ?>
    @output = ""
    run
  end
end

#DELETE THESE

#puts Minifunge.new(%{0"!dlroW ,olleH">:#,_@}, "").run

#Has issues
#puts minifunge(%{~:1+!#@_,}, "TestTest TEST TEST 123456789!!!!")