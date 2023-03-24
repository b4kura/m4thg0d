require_relative 'ScraperMenus.rb'
require_relative 'ScraperQuestoes.rb'
require_relative 'Display.rb'

class MathGOD
  include ScraperMenus
  include ScraperQuestoes
  include Display

  def show_menus
    @sair = false
    mostrar_menu_inicial
    exit if gets.chomp.to_i == 2
    system('clear')
    iteracao_completa
    loop do
      mostrar_menu_retornar
      res = gets.chomp.to_i
      system('clear')
      case res
      when 1
        if @chosen_sub_menu
          questao = montar_questao_aleatoria formatar_string(@chosen_sub_menu[:titulo])
          mostrar_questao questao
        else
          questao = montar_questao_aleatoria formatar_string(@chosen_main_subj[:titulo])
          mostrar_questao questao
        end
      when 2 
        iteracao_completa
      when 3  
        exit
      else
        puts "desculpe, não entendi o comando"
      end
    end
  end

  def iteracao_completa
    @json_main_menus = scrape_main_menus
    mostrar_menu_titulos @json_main_menus
    chosen_menu = gets.chomp.to_i
    system('clear')
    @chosen_main_subj = @json_main_menus.select { |obj| obj[:id] == chosen_menu }[0]
    if scrape_submenus @chosen_main_subj[:id] and abrir_subtitulos?
      @json_sub_menus = scrape_submenus @chosen_main_subj[:id]
      mostrar_menu_titulos @json_sub_menus
      chosen_submenu = gets.chomp.to_i
      system('clear')
      @chosen_sub_menu = @json_sub_menus.select { |obj| obj[:id] == chosen_submenu }[0]
      questao = montar_questao_aleatoria formatar_string(@chosen_sub_menu[:titulo])
      mostrar_questao questao
    else
      questao = montar_questao_aleatoria formatar_string(@chosen_main_subj[:titulo])      
      mostrar_questao questao
    end
  end

  def formatar_string str
    str.downcase.split.join('-').gsub(/[áãà]/, 'a').gsub(/[éèê]/, 'e').gsub(/[íìĩ]/, 'i').gsub(/[óòõô]/, 'o').gsub(/[úù]/, 'u').gsub("ç", 'c')
  end
end

x = MathGOD.new 
x.show_menus



