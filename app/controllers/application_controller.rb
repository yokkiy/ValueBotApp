class ApplicationController < ActionController::Base
  def hello
    render html: "hello, world!"
  end

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

       #result = result.to_i

      # ファイルへ書き込み
      CSV.open("test.csv", "wb") do |csv|
        csv << results
      end
  end

end
