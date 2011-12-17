class CSVParser
  path = 'winners_losers_with_attributes.csv'
  lines = IO.readlines(path)
  newLines = Array.new()
  i = 0
  lines.map do |line|
    if(i==0)
      description = "Second letter of first name"
      newLines.insert(0,line.chomp + ',' + description)
    else
      name = line.split(",").first
      firstname = name.split(" ").first
      lastname = name.split(" ").last
      value = firstname[1, 1]
   puts value
      newLines.insert(-1, line.chomp+','+value.to_s)
    end
    i = i + 1
  end
  #File.open(path, 'w') do |file|
  #  file.puts newLines
  #end

end