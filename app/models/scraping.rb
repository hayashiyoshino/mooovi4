class Scraping

  def self.movie_urls
    #まずself.movie_urlsメソッドが実行される。
    links = []
    #linksというArrayクラスのインスタンス定義
    agent = Mechanize.new
    #M3chanizeクラスのインスタンスを生成
    next_url = ""
    #next_urlというstringクラスのインスタンス定義

    while true
      # 次のページへ飛ぶためのURLを取得し、linksという配列に入れるためのwhile文
      current_page = agent.get("http://review-movie.herokuapp.com/" + next_url)
      #http://review-movie.herokuapp.com/というページの情報を取得し、current_pageという変数に代入
      #while文の２周目からはhttp://review-movie.herokuapp.com/にnext_url足したページ取得
      elements = current_page.search('.entry-title a')
      #entry-titleというcssクラス配下のaタグ取得し、elementsという変数に代入
      elements.each do |ele|
        links << ele.get_attribute('href')
        #elements(entry-title配下のaタグ)の中のhref属性の値を取得し、linksという配列に入れている
      end

      next_link = current_page.at('.pagenation .next a')
      #pagenationというcssクラス配下のnextというcssクラス配下のaタグを取得し、next_linkという変数に代入
      break unless next_link
      # next_linkがなかったらwhile文抜ける
      next_url = next_link.get_attribute('href')
      # 先ほど取得したタグの中のhref属性の値をnext_urlという変数に代入
    end

    links.each do |link|
      get_product("http://review-movie.herokuapp.com/" + link)
      # self.get_productメソッド実行。引数にページのURL持っていく
    end
  end

  def self.get_product(link)
    agent = Mechanize.new
    page = agent.get(link)
    title = page.at('.post h2').inner_text
    image_url = page.at('.entry-content img')[:src] if page.at('.entry-content img')
    director = page.at('.director span').inner_text if page.at('.director span')
    detail = page.at('.entry-content p').inner_text if page.at('.entry-content p')
    open_date = page.at('.date span').inner_text if page.at('.date span')
    product = Product.where(title: title, image_url: image_url, director: director, detail: detail, open_date: open_date).first_or_initialize
    product.save
  end
end
