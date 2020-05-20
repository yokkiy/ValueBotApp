class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

    #webに接続するためのライブラリ
    require "open-uri"
    #クレイピングに使用するライブラリ
    require "nokogiri"

    require 'csv'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    #client.reply_message(event['replyToken'], scraping)
    def scraping

      #クレイピング対象のURL
      url = "https://www.amazon.co.jp/%E4%BB%BB%E5%A4%A9%E5%A0%82-%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%95%E3%82%A3%E3%83%83%E3%83%88-%E3%82%A2%E3%83%89%E3%83%99%E3%83%B3%E3%83%81%E3%83%A3%E3%83%BC-Switch/dp/B07XV8VSZT?pf_rd_r=H89BSZVT52KT9823EBB2&pf_rd_p=2b46ae95-02b2-47c7-99a0-4fae5fa95d48&pd_rd_r=773ef653-8700-4a41-8918-e3e6683064bf&pd_rd_w=Vhljk&pd_rd_wg=ITOQ7&ref_=pd_gw_ci_mcx_mr_hp_d"
      #url = "https://www.amazon.co.jp/%E3%83%A6%E3%83%BC%E3%83%93%E3%83%BC%E3%82%A2%E3%82%A4-%E3%82%BD%E3%83%95%E3%83%88-%E3%82%B8%E3%83%A3%E3%82%B9%E3%83%88%E3%83%80%E3%83%B3%E3%82%B92020-Switch/dp/B083QTPPPG/ref=pd_aw_sbs_63_11?_encoding=UTF8&pd_rd_i=B083QTPPPG&pd_rd_r=9309e994-b205-4ba4-85dd-acd0779711bf&pd_rd_w=9AZP4&pd_rd_wg=DkgN8&pf_rd_p=bff3a3a6-0f6e-4187-bd60-25e75d4c1c8f&pf_rd_r=ND3RQSRBMB7JNPHW4VC8&psc=1&refRID=ND3RQSRBMB7JNPHW4VC8"
      opt = {}
      #opt['User-Agent'] = 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01 '

      #doc = Nokogiri::HTML(open(url, 'User-Agent' => 'Googlebot/2.1'))

      html = open(url, 'User-Agent' => 'Googlebot/2.1')
      doc = Nokogiri::HTML.parse(html, nil, "UTF-8")

      result = "現在、Amazonからの出品がありません。"

        results = []
        values = []
        doc.xpath('//span[contains(@id, "priceblock_ourprice")]').each do |node|
          value = node.xpath('//span[contains(@class, "a-size-medium a-color-price priceBlockBuyingPriceString")]').text
          results << value
        end

        doc.xpath('//div[@class="a-text-center a-spacing-mini"]').each do |node|
          value = node.css('span').inner_text
          values << value
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


        link = "商品リンク"

      if results.empty? then
        value = nil

        values.each do |list|
          if list != nil then
            if list.include?("￥") then
              value = list
              value = value.delete("￥")
              value = value.delete(",")
            end
          end
        end
        current = "現在の価格："
        final = result.encode("sjis") + "\r\n\r\n" + current.encode("sjis") + value.encode("sjis") + "\r\n\r\n" + link.encode("sjis") + "\r\n" + url.encode("sjis")

      else
        sale = "Amazonから出品されました："
        final = sale.encode("sjis") + result.encode("sjis") + "\r\n\r\n" + link.encode("sjis") + "\r\n" + url.encode("sjis")

      end

         return final

    end

    #while true do
    #  message = {
    #    type: 'text',
    #    text: scraping()
    #  }
    #response = client.push_message("U5767a0b6aac44ac2f9e42e049957f109", message)
    #sleep(60)
    #end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: scraping()
          }
          client.reply_message(event['replyToken'], message)
          #client.push_message("U5767a0b6aac44ac2f9e42e049957f109", message)
          #client.push_message("Uf31ad9dd1052998a23d51d4117ca7d18", message)
        end
      end
  }

    head :ok
  end
end
