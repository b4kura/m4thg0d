module Display
  def mostrar_menu_inicial
    puts "\n-----------------------------------------------\n"
    puts "[1] menu principal"
    puts "[2] sair"
    puts "-----------------------------------------------\n"
  end
  def mostrar_menu_titulos json
    json.each do |obj|
      puts "[#{obj[:id]}] #{obj[:titulo]}"
    end
  end
  def abrir_subtitulos?
    print "\nabrir subtítulos? [s/n] "
    res = gets.chomp
    system('clear')
    res.downcase == 's'
  end
  def mostrar_menu_retornar
    puts "\n-----------------------------------------------\n"
    puts "[1] mais uma questão"
    puts "[2] mostrar menu principal"
    puts "[3] sair"
    puts "-----------------------------------------------\n"
  end
end



