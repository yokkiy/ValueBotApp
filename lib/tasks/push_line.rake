namespace :push_line do
  require 'line/bot'  # gem 'line-bot-api'

    #webに接続するためのライブラリ
    require "open-uri"
    #クレイピングに使用するライブラリ
    require "nokogiri"

  def scraping

    #クレイピング対象のURL
    url = "https://www.amazon.co.jp/%E4%BB%BB%E5%A4%A9%E5%A0%82-%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%95%E3%82%A3%E3%83%83%E3%83%88-%E3%82%A2%E3%83%89%E3%83%99%E3%83%B3%E3%83%81%E3%83%A3%E3%83%BC-Switch/dp/B07XV8VSZT/ref=sr_1_1?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&dchild=1&keywords=%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%95%E3%82%A3%E3%83%83%E3%83%88%E3%82%A2%E3%83%89%E3%83%99%E3%83%B3%E3%83%81%E3%83%A3%E3%83%BC&qid=1588166354&s=videogames&sr=1-1"

    opt = {}
    opt['User-Agent'] = 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01 '

    doc = Nokogiri::HTML(open(url, opt))

    result = "現在、Amazonからの出品がありません。"

      results = []

      doc.xpath('//span[contains(@id, "priceblock_ourprice")]').each do |node|
        #result = node.css('span').inner_text
        value = node.xpath('//span[contains(@class, "a-size-medium a-color-price priceBlockBuyingPriceString")]').text
        results << value
      end

      results.each do |list|
        if list != nil then
          if list.include?("￥") then
            result = list
            result = result.delete("￥")
            result = result.delete(",")
          end
        end
      end

      current = "定価販売されました："
      link = "商品リンク"

      if !results.empty? then
        final = current.encode("sjis") + result.encode("sjis") + "\r\n\r\n" + link.encode("sjis") + "\r\n" + url.encode("sjis")
      else
        final = nil
      end
      #results = []
      #results << result
      #results << url
       #return result.encode("sjis") + "\r\n" + value.encode("sjis") + "\r\n商品ページ" + url
       return final
       #return result
  end

  desc "push_line"
  task push_line_message_amazon: :environment do # 以下にpush機能のタスクを書く。
    message = {
      type: 'text',
      text: scraping()
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = "3319af8334b57079583a8a2109a85d58"
      config.channel_token = "PqxhR3tXmWQJ52KuOnhVWF4Kxi+nkk6SHKvTl/htjHysuJGYfcv7hIa7FKaCTdvZEQBi/1MScj3EAWUjCHGg2gNs5Sgcuis4QmukhLn8jB0o+F71zEa9XVKXB7+e2Ev8EkHfd9UUVNf6BuYiICJjSQdB04t89/1O/w1cDnyilFU="
    }
      client.push_message("U5767a0b6aac44ac2f9e42e049957f109", message)
      client.push_message("Uf31ad9dd1052998a23d51d4117ca7d18", message)
  end

end
