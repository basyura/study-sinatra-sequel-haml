
class Comment < Sequel::Model
  attr_accessor :deep
  one_to_many   :comments
  set_schema do 
    primary_key :id
    foreign_key :comment_id , :comments
    string      :name
    string      :title
    text        :message
    timestamp   :posted_date
  end
  def date
    self.posted_date.strftime("%Y-%m-%d %H:%M:%S") if self.posted_date
  end
  def formated_message
    Rack::Utils.escape_html(self.message).gsub(/\n/ , '<br>')
  end
  def replies(deep=1)
    list = comments.inject([]) do |list , c|
      c.deep = deep
      list << c
      list += c.replies(deep + 1)
    end
  end
end

Comment.create_table unless Comment.table_exists?
