#!/usr/bin/env ruby
#c言語プログラミングでcファイルのコンパイルを楽にしたい人用
#一応分割コンパイルにも対応
env = ENV['CBPATH']
$LOAD_PATH.push("$CBPATH/")
require "env"#強引require

#他のクラスのベース run関数を宣言
class Command
  attr_accessor :argv
  def initialize(argv)
    @argv = argv
  end
  def run
  end
end

#cファイルをmakeするクラス
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

#makeして実行するクラス
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

  def exe
    #puts "run #{@argv[0]}" #@argv[0]はBuildクラスで削除されている
    #system("./#{@argv[0]}")
    str = runCommand(@argv)
    puts "run #{str}"
    system(str)
  end
end


#.cファイルを作成し MakefileにTARGETに追加する
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
    puts "#{str}をMakefileに追加"
  end

  def replaceC(str)
    time = Time.new
    time = time.strftime("%Y/%m/%d")
    buffer = File.open("#{str}.c","r"){|f| f.read }
    buffer = buffer.gsub(/(^ +作成日:).*/,"\\1 #{time}")
    buffer = buffer.gsub(/(^ +作成者:).*/,"\\1 #{$author}")
    buffer = buffer.gsub(/(^ +学籍番号:).*/,"\\1 #{$id}")
    buffer = buffer.gsub(/(^ +ソースファイル名:).*/,"\\1 #{str}.c")
    buffer = buffer.gsub(/(^ +実行ファイル名:).*/,"\\1 #{str}")
    File.open("#{str}.c","w"){|f| f.write(buffer) }
  end

  def genC
    if !(File.exist?("Makefile")) then
      puts "Makefileを作成してください．"
      exit
    end
    if @argv.size==1 then
      puts "作成するcファイル名を指定してください"
      exit
    end
    str = "cp $CBPATH/tmpl/gen.c.tmpl "
    @argv.delete_at(0)
    @argv.each{|i|
      tmp = i + ".c"
      if !File.exist?(tmp) then
        #puts str + tmp
        addMake(i)
        system(str+tmp)
        replaceC(i)
        puts "#{tmp}を作成"
      else
        puts tmp + "はすでに存在します"
      end
    }
  end
end

#.hファイルを作成し，Makefileに追加する
class GenH < Command
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
    puts "#{str}.hをMakefileに追加"
  end

  def replaceH(str)
    time = Time.new
    time = time.strftime("%Y/%m/%d")
    buffer = File.open("#{str}.h","r"){|f| f.read }
    buffer = buffer.gsub(/(^ +作成日:).*/,"\\1 #{time}")
    buffer = buffer.gsub(/(^ +作成者:).*/,"\\1 #{$author}")
    buffer = buffer.gsub(/(^ +学籍番号:).*/,"\\1 #{$id}")
    buffer = buffer.gsub(/(^ +ヘッダファイル名:).*/,"\\1 #{str}.h")
    File.open("#{str}.h","w"){|f| f.write(buffer) }
  end

  def genH
    if !(File.exist?("Makefile")) then
      puts "Makefileを作成してください．"
      exit
    end
    if @argv.size==1 then
      puts "作成するhファイル名を指定してください"
      exit
    end
    str = "cp $CBPATH/tmpl/genh.c.tmpl "
    @argv.delete_at(0)
    @argv.each{|i|
      tmp = i + ".h"
      if !File.exist?(tmp) then
        #puts str + tmp
        addMake(i)

        system(str+tmp)
        replaceH(i)
        puts "#{tmp}を作成"
      else
        puts tmp + "はすでに存在します"
      end
    }
  end
end

#.cファイルを作成するがMakefileには追加しない
class GenF < Command
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
    puts "#{str}をMakefileに追加"
  end

  def replaceC(str)
    time = Time.new
    time = time.strftime("%Y/%m/%d")
    buffer = File.open("#{str}.c","r"){|f| f.read }
    buffer = buffer.gsub(/(^ +作成日:).*/,"\\1 #{time}")
    buffer = buffer.gsub(/(^ +作成者:).*/,"\\1 #{$author}")
    buffer = buffer.gsub(/(^ +学籍番号:).*/,"\\1 #{$id}")
    buffer = buffer.gsub(/(^ +ソースファイル名:).*/,"\\1 #{str}.c")
    buffer = buffer.gsub(/(^ +実行ファイル名:).*/,"\\1 #{str}")
    File.open("#{str}.c","w"){|f| f.write(buffer) }
  end

  def genF
    if !(File.exist?("Makefile")) then
      puts "Makefileを作成してください．"
      exit
    end
    if @argv.size==1 then
      puts "作成するcファイル名を指定してください"
      exit
    end
    str = "cp $CBPATH/tmpl/genf.c.tmpl "
    @argv.delete_at(0)
    @argv.each{|i|
      tmp = i + ".c"
      if !File.exist?(tmp) then
        #puts str + tmp
        #addMake(i)
        system(str+tmp)
        replaceC(i)
        puts "#{tmp}を作成"
      else
        puts tmp + "はすでに存在します"
      end
    }
  end
end

#Makefileを作成する
class New < Command

  def run
    genMake
  end

  def genMake
    if @argv.size==1 then
      if !Dir.exist?(".cbuild") then
        system("mkdir .cbuild")
      end

      if !(File.exist?("Makefile")||File.exist?("makefile")) then
        system("cp $CBPATH/tmpl/Makefile.tmpl ./Makefile")
        #return true  
      else
        puts "Makefileがすでに存在します"
        #puts "#{@argv.size}"
        #return false
      end
    else
      #puts @argv.size
      puts "引数が多いです"
    end
  end
end

#余分なファイル(.o,実行ファイル)を削除する
class Rm < Command

  def run
    rmOBJ
  end

  def rmOBJ
    if @argv.size==1 then
      system("make clean")
    else
      #puts @argv.size
      puts "引数が多いです"
    end
  end
end

#versionを表示する
class Version < Command
  def run
    catV
  end
  def catV
    system("cat $CBPATH/version.txt")
  end
end

#main関数
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
    command = Version.new(ARGV)
  else
    system("cat $CBPATH/cbuild.txt")
    exit
  end
  command.run
end

#実行
main
