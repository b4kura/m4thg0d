require 'nokogiri'
require 'open-uri'

module ScraperQuestoes 
  @@url_principal = 'https://www.qconcursos.com/questoes-de-vestibular/disciplinas/matematica-matematica/'
  @@alternativas = ('A'..'Z').to_a
  @@max_num_paginas = 10
  
  def montar_questao_aleatoria assunto_escolhido
    num_pagina = rand(1..@@max_num_paginas)
    exit unless pag_exists? "#{@@url_principal}/#{assunto_escolhido}/questoes?page=#{num_pagina}"
    html = Nokogiri::HTML(URI.open("#{@@url_principal}/#{assunto_escolhido}/questoes?page=#{num_pagina}"))
    enunciados = html.xpath('//div[@class="q-question-enunciation"]/@aria-label')
    total_enunciados = enunciados.size
    index_questao = rand(0...total_enunciados)
    return if total_enunciados == 0
    enunciado_atual = enunciados[index_questao].value.gsub("\r", ' ').delete("\n")
    containeres_questoes_pagina = html.css(".q-question-options")
    valores_alternativas_enunciado_atual = containeres_questoes_pagina[index_questao].css('.q-item-enum')

    alternativas_obj = {}
    valores_alternativas_enunciado_atual.size.times do |i|
      alternativas_obj[@@alternativas[i]] = valores_alternativas_enunciado_atual[i].text
    end

    info_prova = html.xpath('//span[@class="q-exams"]//a')[index_questao].text

    questao_montada = {
      prova: info_prova,
      enunciado: enunciado_atual,
      alternativas: alternativas_obj
    }
  end

  def mostrar_questao questao_montada
    puts "\n------------------------------------------------"
    puts "\n[#{questao_montada[:prova]}]"
    puts "\nQuestão: \n\t#{questao_montada[:enunciado]}"
    puts "\nAlternativas:"
    alternativas = questao_montada[:alternativas].keys
    alternativas.size.times do |i|
      puts "\t#{alternativas[i]}. #{questao_montada[:alternativas][alternativas[i]]}"
    end
  end
=begin
  def gerar_questao assunto
    questao = ScraperQuestoes.montar_questao_aleatoria assunto
    ScraperQuestoes.mostrar_questao questao
  end
=end

  def pag_exists? url
    begin 
      URI.open(url)
      true
    rescue OpenURI::HTTPError => err
      puts 'deu erro', err
      false
    end
  end

end


