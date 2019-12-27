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
  attr_accessor :argv
  def initialize(argv)
    @argv = argv
  end
  def run
  end
end


class Build < Command
  def run
    make
  end
  def make
    str = "make "
    @argv.delete_at(0)
    @argv.each{|i|
      str += i + " "
    }
    puts str
    system(str)
  end
end


class Run < Build #Build継承も
  def run
    make
    exe
  end
  
  def make
    if @argv.size==1 then
      puts "実行ファイル名を指定してください"
      exit
    elsif @argv.size!=2 then
      puts "引数多し"
      exit
    end
    super
  end

  def exe
    puts "run #{@argv[0]}" #@argv[0]はBuildクラスで削除されている
    system("./#{@argv[0]}")
  end
end

class Gen < Command
  def run
    genC
  end

  def addMake(str)
    if !Dir.exist?(".cbuild") then
      system("mkdir .cbuild")
    end
  end

  def genC
    if @argv.size==1 then
      puts "作成するcファイル名を指定してください"
      exit
    end
    str = "cp $CBPATH/comment.c.tmpl"
    @argv.delete_at(0)
    @argv.each{|i|
      tmp = i + ".c"
      if File.exist?(tmp) then
        str += tmp
        puts str
        system(str)
      else
        puts tmp + "はすでに存在します"
      end
    }
  end
end

class New < Command
  #attr_accessor :argv
  #def initialize(argv)
  #    @argv = argv
  #end

  def run
    genMake
  end

  def genMake
    if @argv.size==1 then
      if !Dir.exist?(".cbuild") then
        system("mkdir .cbuild")
      end

      if !(File.exist?("Makefile")||File.exist?("makefile")) then
        system("cp $CBPATH/Makefile.tmpl ./Makefile")
        #return true  
      else
        puts "Makefileがすでに存在します"
        puts "#{@argv.size}"
        #return false
      end
    else
      puts @argv.size
      puts "引数が多いです"
    end
  end
end

def main
  if ARGV.size == 0
    system("cat $CBPATH/cbuild.txt")
    exit
  end
  
  case ARGV[0]
  when "build"
    command = Build.new(ARGV)
  when "run"
    command = Run.new(ARGV)
  when "gen"
    command = Gen.new(ARGV)
  when "new"
    command = New.new(ARGV)
  else
    system("cat $CBPATH/cbuild.txt")
    exit
  end
  command.run
end


main


#ここからいらなくなるだろう

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
  

#case ARGV.size
#when 1 then
  #puts "1"
#  one
#when 2 then
  #puts "2"
#  two
#else
  #puts "else"
#  system("cat $CBPATH/cbuild.txt")
#end
