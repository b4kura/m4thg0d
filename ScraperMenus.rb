require 'nokogiri'
require 'open-uri'

module ScraperMenus
  @@site = 'https://www.qconcursos.com'
  @@url_menus = 'https://www.qconcursos.com/questoes-de-vestibular/disciplinas/matematica-matematica'
  def scrape_main_menus
    doc = Nokogiri::HTML(URI.open(@@url_menus))    
    a_tags = doc.xpath('//div[@class="panel-heading"]//h2[@class="q-title"]//a')
    json_main_menus = a_tags.map.with_index do |a_tag, i|
      {
        id: i + 1,
        titulo: a_tag.text.gsub(/[\d\.]/, "").strip,
        link: a_tag['href']
      }
    end
    json_main_menus
  end
  
  def scrape_submenus num_menu
    html = Nokogiri::HTML(URI.open(@@url_menus))    
    submenus = [] 
    main_container = html.xpath("//div[@id=\"collapse-#{num_menu}\"]")
    if main_container.size > 0
      main_container = Nokogiri::XML(main_container.to_s)
      main_container.css('li').each.with_index do |submenu_container, i| 
        titulo_submenu = Nokogiri::XML(submenu_container.to_s).xpath('//a[@class="q-link"]//span[2]').text
        link_submenu = Nokogiri::XML(submenu_container.to_s).xpath('//a[@class="q-link"]')[0]['href']
        submenus[i] = {
          id: i + 1,
          titulo: titulo_submenu,
          link: @@site + link_submenu + '/questoes'
        }
      end
    else 
      return false
    end
    submenus
  end

end

