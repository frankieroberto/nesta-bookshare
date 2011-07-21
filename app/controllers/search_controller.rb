class SearchController < ApplicationController
  def index
    @q = params[:q].strip.downcase


    case ActiveRecord::Base.connection.adapter_name
    when 'SQLite'
      @titles = Title.find_by_sql(["
        SELECT *
        FROM titles
        WHERE title LIKE ? OR subtitle LIKE ?", "%#{@q}%", "%#{@q}%"])
    else
      @titles = Title.find_by_sql(["
        SELECT *
        FROM titles
        WHERE LOWER(TEXTCAT(TEXTCAT(title, ' '), subtitle)) LIKE(?)", "%#{@q}%"
      ])
    end
#     @type = params[:type]
#     if @type == 'titles'
      # sqlite uses || operator to concat strings, postgres uses TEXTCAT
      Search.create(:query => @q, :results => @titles.count)

#     elsif @type == 'authors'
#       @titles = Author.find_by_sql("
#         SELECT t.*
#         FROM authors a
#         LEFT JOIN titles t
#         ON t
#         WHERE title || ' ' || subtitle LIKE('%#{params[:q]}%')
#       " )
#     else
#       @titles = []
#     end
  end
end
