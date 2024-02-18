require 'io/console'

class GapBuffer
  def initialize
    @buff = Array.new(10)
    @total = 10
    @gap = 10
    @front = 0
  end

  def insert(c)
    if @gap == 0
      new_buff = Array.new(@total * 2)
      new_buff[0...@front] = @buff[0...@front]
      new_buff[(@front + @total)..-1] = @buff[(@front + @gap)..-1]
      @buff = new_buff
      @gap = @total
      @total = @total * 2
    end

    @gap -= 1
    @buff[@front] = c
    @front += 1
  end

  def insert_str(str)
    str.each_char do |c|
      insert(c)
    end
  end

  def delete
    @gap += 1
    @front -= 1
    @buff[@front] = nil
  end

  def backward
    @front -= 1
    @buff[@front + @gap] = @buff[@front]
    @buff[@front] = nil
  end

  def forward
    @buff[@front] = @buff[@front + @gap]
    @buff[@front + @gap] = nil
    @front += 1
  end

  def display
    contents = @buff.map do |c|
      c || "_"
    end.join

    """
    @gap = #{@gap}, @front = #{@front}, @total = #{@total}
    buffer: #{contents}
    """
  end
end

# This is stupid, I know.
init = """
Buffer is created. Its initial states are:
- @total = 10
- @gap = 10 # size of the gap
- @front = 0 # marks the start of the gap
"""

puts init

io = IO.console
current_r, current_c = io.cursor

intro = """
As you insert characters, @front advances and the @gap shrinks.
----------------------------------------------------------------------------------------------------------------------------------
"""
puts intro
sleep 1

a = GapBuffer.new
current_r, current_c = io.cursor
"hello".each_char.with_index do |c, i|
  sleep 1
  print c

  a.insert(c)

  io.goto(current_r + 1, current_c)
  print a.display

  io.goto(current_r, current_c + i + 1)
end

io.goto(current_r + 4, current_c)

b = """

When you move cursor backward/forward, @front decreases/increases, and the @gap is moved along the same direction with the cursor.
Character is copied back and forth to make room for new insertion.
----------------------------------------------------------------------------------------------------------------------------------"""
puts b
sleep 3

current_r, current_c = io.cursor
puts "hello"
puts a.display

2.times do |i|
  sleep 1
  io.goto(current_r, current_c + 5 - (i + 1))
  a.backward

  io.goto(current_r + 1, current_c)
  print a.display
  io.goto(current_r, current_c + 5 - (i + 1))
end

current_r, current_c = io.cursor
2.times do |i|
  sleep 1
  io.goto(current_r, current_c + i + 1)
  a.forward

  io.goto(current_r + 1, current_c)
  print a.display
  io.goto(current_r, current_c + i + 1)
end

current_r, current_c = io.cursor
2.times do |i|
  sleep 1
  io.goto(current_r, current_c - (i + 1))
  a.backward

  io.goto(current_r + 1, current_c)
  print a.display
  io.goto(current_r, current_c - (i + 1))
end

current_r, current_c = io.cursor
"12345".each_char.with_index do |c, i|
  sleep 1
  print "#{c}lo"

  a.insert(c)

  io.goto(current_r + 1, current_c)
  print a.display

  io.goto(current_r, current_c + i + 1)
end

sleep 1

current_r, current_c = io.cursor

resize = """
When the gap is zero, you need to resize the buffer.
1. Allocate a new buffer with a double (up to you) of current @total
2. Copy what is in front of @front to the new buffer
3. Set the new buffer gap as @total
4. Copy what is behind the @gap to the new buffer

"""

io.goto(current_r + 4, current_c)
puts resize
sleep 3

current_r, current_c = io.cursor
puts "hel12345lo"
puts a.display
io.goto(current_r, current_c + 8)

sleep 3
a.insert('6')
print "6lo"

io.goto(current_r + 1, current_c)
puts a.display

gets
