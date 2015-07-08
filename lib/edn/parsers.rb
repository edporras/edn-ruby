parsers = [ 'native_parser', 'ext_parser' ]

parsers.each do |path|
  parser_path = File.join(File.dirname(__FILE__), path)

  if Dir::exists?(parser_path)
    Dir[File.join(parser_path, '*.*')].each do |file|
      require file
    end
  end
end
