class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["3319af8334b57079583a8a2109a85d58"]
      config.channel_token = ENV["PqxhR3tXmWQJ52KuOnhVWF4Kxi+nkk6SHKvTl/htjHysuJGYfcv7hIa7FKaCTdvZEQBi/1MScj3EAWUjCHGg2gNs5Sgcuis4QmukhLn8jB0o+F71zEa9XVKXB7+e2Ev8EkHfd9UUVNf6BuYiICJjSQdB04t89/1O/w1cDnyilFU="]
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
      #webに接続するためのライブラリ
      require "open-uri"
      #クレイピングに使用するライブラリ
      require "nokogiri"

      require 'csv'

      #クレイピング対象のURL
      url = "https://www.amazon.co.jp/%E4%BB%BB%E5%A4%A9%E5%A0%82-%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%95%E3%82%A3%E3%83%83%E3%83%88-%E3%82%A2%E3%83%89%E3%83%99%E3%83%B3%E3%83%81%E3%83%A3%E3%83%BC-Switch/dp/B07XV8VSZT/ref=sr_1_1?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&dchild=1&keywords=%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%95%E3%82%A3%E3%83%83%E3%83%88%E3%82%A2%E3%83%89%E3%83%99%E3%83%B3%E3%83%81%E3%83%A3%E3%83%BC&qid=1588166354&s=videogames&sr=1-1"

      opt = {}
      opt['User-Agent'] = 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01 '

      doc = Nokogiri::HTML(open(url, opt))

      result = nil

        results = []

        doc.xpath('//div[@class="a-text-center a-spacing-mini"]').each do |node|
          result = node.css('span').inner_text
          results << result
        end



        results.each do |list|
          if list != nil then
            if list.include?("￥") then
              result = list
            end
          end
        end

        result = result.delete("￥")
        result = result.delete(",")

         return result
    end

    #events = client.parse_events_from(body)
    while true do
            client.reply_message(event['replyToken'], scraping)
            sleep(60)
    end
    #events.each { |event|
  #    case event
  #    when Line::Bot::Event::Message
  #      case event.type
  #      when Line::Bot::Event::MessageType::Text
  #        message = {
  #          type: 'text',
  #          text: event.message['text']
  #        }
  #        client.reply_message(event['replyToken'], message)
  #      end
  #    end
  #}

    head :ok
  end
end
