# ruby replacement.rb dir_name で実行

# アプリケーションの設置ディレクトリの取得を行うクラス
class FileGet
  attr_accessor :file_name
  attr_reader :dir_list

  def initialize(dir_name)
    @dir_list  = get_dir(dir_name)
    @file_name = "/app/views/tasks/index.html"
  end

  # directoryを取得
  def get_dir(dir_name)
    Dir.glob("#{dir_name}*/")
  end

  # 置換するファイルのパスを取得
  def get_file_list
    file_path_list = []
    @dir_list.each do |dir|
      file_path       = "#{dir}#{@file_name}"
      file_path_list << file_path if File.exist?(file_path)
    end
    return file_path_list
  end
end

# ファイルの置換を行うクラス
class ReplaceText
  attr_accessor :pattern, :replacement
  def initialize(file_list=[])
    @file_list   = file_list
    @pattern     = /Time\.now$/
    @replacement = "Time.now.utc"
  end

  def replace_files
    @file_list.each { |l| exec(l) }
  end

  private

  def exec(path)
    # 読み取り専用でファイルを開き、内容をbufferに代入
    buffer = File.open(path, "r") { |f| f.read() }

    # バックアップ用ファイルを開いて、バッパを書き込む（バックアップ作成）
    File.open("#{path}.bak" , "w") { |f| f.write(buffer) }

    # bufferの中身を変換
    buffer.gsub!(@pattern, @replacement)

    # bufferを元のファイルに書き込む
    File.open(path, "w") { |f| f.write(buffer) }
  end
end

# アプリケーションの設置ディレクトリの取得
file_get  = FileGet.new("./#{ARGV[0]}/")
file_list = file_get.get_file_list

# 置換の実行
if file_list.count > 0
  r = ReplaceText.new(file_list)
  r.replace_files
end
