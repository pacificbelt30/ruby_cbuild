class Oya
  attr_accessor :x
  def initialize(x)
    @x = x
  end
  def a
    puts @x
    puts self.x
  end
end

class Ko < Oya
  def b
    puts @x
    puts self.x
  end
end

class Ko2 < Ko
  def c
    puts @x
  end
  def b
    super
    puts @x
  end
end

puts "引数の数 #{ARGV.size.to_s}"
#イテレータでコマンドラインに";コマンド"とうつとそのコマンドが実行される
ARGV.each {|i|
  print "#{i.to_s}1"
}

puts ";ls"

oya = Oya.new("aaa")
oya.a

ko = Ko.new("bbb")
ko.b
ko.a

ko2 = Ko2.new("ccc")
ko2.c
ko2.b
