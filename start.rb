require 'haml'
require 'sinatra'
require 'sequel'
require 'logger'

Sequel::Model.plugin(:schema)
db = Sequel.connect("sqlite://db/comments.db")
db.loggers << Logger.new($stderr)

require './model/comment'

get '/' do
  @comments = Comment.filter(:comment_id => nil).order_by(:posted_date.desc)
  haml :index
end

put '/comment' do
  Comment.create({
    :comment_id  => request[:comment_id],
    :name        => request[:name],
    :title       => request[:title],
    :message     => request[:message],
    :posted_date => Time.now,
  })

  redirect '/'
end

helpers do
  include Rack::Utils; alias_method :h, :escape_html
end
