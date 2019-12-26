#!/usr/bin/env ruby
#/^TARGET/
#if File.exist?("S1/Makefile") then
#  print "aa\n"
#end

#puts $0
#
#def run(name)
#  stdtxt = "./stdout.txt"
#  out = system("#{name} 2> #{stdtxt} 1> #{stdtxt}")
#  system("cat #{stdtxt}")
#end

class Command
  def run
  end
end

class Run < Command
  def initialize
  
  end
end

class Gen < Command
  def initialize
    
  end
end



class Build < Command
  def initialize
  end
  def fileget
  end
end

class New < Command
  def initialize(argc)
      @argc = argc
  end
  def fileexist(filename)
    if !(File.exist?("Makefile")||File.exist?("makefile")) then
      system("cp $CBPATH/Makefile.tmpl ./Makefile")  
    else
      puts "Makefileがすでに存在します"
    end
  end
end

#puts ARGV[0]
def one
case ARGV[0]
when "new" then
  puts "new"
  if !(File.exist?("Makefile")||File.exist?("makefile")) then
#system("cp $CBPATH/Makefile.tmpl ./")
    system("cp $CBPATH/Makefile.tmpl ./Makefile")  
  else
    puts "makefileがすでに存在します"
  end
when "build" then
  puts "build"
  system("make");
  #run(make)
  #puts $?
when "run" then
  puts "実行ファイル名を指定してください"
when "gen" then
  puts "作成するファイル名(拡張子を除く)を入力してください。"
else
  #puts "else"
  system("cat $CBPATH/cbuild.txt")
end
end

def two
case ARGV[0]
when "new" then
  puts "new"
  if !(File.exist?("Makefile")||File.exist?("makefile")) then
#system("cp $CBPATH/Makefile.tmpl ./")
    system("cp $CBPATH/Makefile.tmpl ./makefile")
  else
    puts "makefileがすでに存在します"
  end
when "build" then
  puts "build"
  make = "make "+ARGV[1]
  system(make);
when "run" then
  puts "run"
  make = "make "+ARGV[1]
  system(make)
  if (File.exist?("#{ARGV[1]}.in")) then
  run = "./" + ARGV[1]+"< "+ARGV[1]+".in"
  puts "input: "+ARGV[1]+".in"
  else
  run = "./" + ARGV[1]
  end
  puts "#{ARGV[1]}実行"
  system(run)
#when /.+\.in/
#  puts "itti"
when "gen" then
  puts "gen"
  if (File.exist?("#{ARGV[1]}.c")) then
    puts "そのファイル名存在するぜ"
  else
    gen = "cp $CBPATH/comment.c.tmpl ./" + ARGV[1]+".c"
    system(gen)
  end
 
else
  puts "else"
  system("cat $CBPATH/cbuild.txt")
end
end

#ARGV.each{|i|
#case i
#when "build" then
#  puts "build"
#when "run" then
#  puts "run"
#else
#  puts "else"
#  system("cat cbuild.txt")
#end
#}

case ARGV.size
when 1 then
  #puts "1"
  one
when 2 then
  #puts "2"
  two
else
  #puts "else"
  system("cat $CBPATH/cbuild.txt")
end


