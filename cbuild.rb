#!/usr/bin/env ruby
#c言語プログラミングでcファイルのコンパイルを楽にしたい人用
#一応分割コンパイルにも対応

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
      if !(/^-.*/=~i) then
      str += i + " "
      end
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

  def numOption
    a = 0
    @argv.each{|i|
      if /^-.*/=~i then
        a += 1
      end
    }
    return a
  end

  #オプションでin,outに対してなにかしたい
  def make
    if @argv.size==1 then
      puts "実行ファイル名を指定してください"
      exit
    elsif @argv.size>3 then
      puts "引数多し"
      exit
    elsif @argv.size == 3 && numOption != 1 then
      puts "実行ファイルは2つ以上指定できません"
      exit
    elsif @argv.size == 2 && numOption !=0 then
      puts "実行ファイル名を指定してください"
      exit 
    end
    super#@argv[0]削除
  end

  def reg(str)
    num = 0
    if /^-.*/=~str then
      if str.include?("i") then
        num += 1
      end
      if str.include?("o") then
         num += 2 
      end
    end
    return num
  end

  def runCommand(argv)
    num = 0
    str = ""
    argv.each{|i|
      if !(/^-.*/=~i) then
        str = i
      else
        num = reg(i)
      end
    }
    case num
    when 0
      command = "./#{str}"
    when 1
      command = "./#{str} < #{str}.in"
    when 2
      command = "./#{str} > #{str}.out"
    when 3
      command = "./#{str} < #{str}.in > #{str}.out"
    else
      command = ""
    end
    return command
  end

end


def exe
  #puts "run #{@argv[0]}" #@argv[0]はBuildクラスで削除されている
  #system("./#{@argv[0]}")
  str = runCommand(@argv)
  puts "run #{str}"
  system(str)
end



class Gen < Command
  def run
    genC
  end

  def addMake(str)
    if !Dir.exist?(".cbuild") then
      system("mkdir .cbuild")
    end
    time = Time.new
    time = time.strftime("%Y-%m-%d-%H:%M:%S")
    buffer = File.open("Makefile","r"){|f| f.read }
    File.open("./.cbuild/#{time}Makefile.bak","w"){|f| f.write(buffer) }
    buffer = buffer.gsub(/(^TARGET.*)/,"\\1 #{str}")
    File.open("Makefile","w"){|f| f.write(buffer) }
  end

  def genC
    if @argv.size==1 then
      puts "作成するcファイル名を指定してください"
      exit
    end
    str = "cp $CBPATH/comment.c.tmpl"
    @argv.delete_at(0)
    @argv.each{|i|
      tmp = " " + i + ".c"
      if !File.exist?(tmp) then
        puts str + tmp
        addMake(i)

        system(str+tmp)
      else
        puts tmp + "はすでに存在します"
      end
    }
  end
end

class GenH
  def run
    genH
  end

  def addMake(str)
    if !Dir.exist?(".cbuild") then
      system("mkdir .cbuild")
    end
    time = Time.new
    time = time.strftime("%Y-%m-%d-%H:%M:%S")
    buffer = File.open("Makefile","r"){|f| f.read }
    File.open("./.cbuild/#{time}Makefile.bak","w"){|f| f.write(buffer) }
    buffer = buffer.gsub(/(^HF.*)/,"\\1 #{str}.h")
    File.open("Makefile","w"){|f| f.write(buffer) }
  end

  def genH
    if @argv.size==1 then
      puts "作成するhファイル名を指定してください"
      exit
    end
    str = "cp $CBPATH/comment.h.tmpl"
    @argv.delete_at(0)
    @argv.each{|i|
      tmp = " " + i + ".h"
      if !File.exist?(tmp) then
        puts str + tmp
        addMake(i)

        system(str+tmp)
      else
        puts tmp + "はすでに存在します"
      end
    }
  end
end

class GenF
  def run
    genF
  end

  def addMake(str)
    if !Dir.exist?(".cbuild") then
      system("mkdir .cbuild")
    end
    time = Time.new
    time = time.strftime("%Y-%m-%d-%H:%M:%S")
    buffer = File.open("Makefile","r"){|f| f.read }
    File.open("./.cbuild/#{time}Makefile.bak","w"){|f| f.write(buffer) }
    buffer = buffer.gsub(/(^FUNC.*)/,"\\1 #{str}")
    File.open("Makefile","w"){|f| f.write(buffer) }
  end

  def genF
    if @argv.size==1 then
      puts "作成するcファイル名を指定してください"
      exit
    end
    str = "cp $CBPATH/comment.f.tmpl"
    @argv.delete_at(0)
    @argv.each{|i|
      tmp = " " + i + ".h"
      if !File.exist?(tmp) then
        puts str + tmp
        #addMake(i)
        system(str+tmp)
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


class Rm < Command
  #attr_accessor :argv
  #def initialize(argv)
  #    @argv = argv
  #end

  def run
    rmOBJ
  end

  def rmOBJ
    if @argv.size==1 then
      system("make clean")
    else
      puts @argv.size
      puts "引数が多いです"
    end
  end
end

class Version
  def run
    catV
  end
  def catV
    system("cat $CBPATH/version.txt")
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
  when "genh"
    command = GenH.new(ARGV)
  when "genf"
    command = GenF.new(ARGV)
  when "rm"
    command = Rm.new(ARGV)
  when "version"
    command = catV.new(ARGV)
  else
    system("cat $CBPATH/cbuild.txt")
    exit
  end
  command.run
end

#実行
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
