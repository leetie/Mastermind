module Typer
  #include Enumerable
  def typer (speed=0.05)
     # Types strings in terminal
    self.split("").each do |i|
      print i
      sleep speed
    end
    puts ""
  end
end
