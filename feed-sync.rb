require 'sinatra'

get '/last-feed' do
	if !File.exist?(last_feed_id_path)
		logger.info "initialize last-feed.it"
		add_sync_feed_id(0)
	end

	status 200
	last_feed_id
end

post '/last-feed' do
	if !params[:id]
		logger.info "receive bad request without id specified"
		status 400
		return
	end

	add_sync_feed_id(params[:id])
	status 201
end

def last_feed_id_path
	"#{File.dirname(__FILE__)}/last-feed.id"
end

def add_sync_feed_id(id)
	logger.info "sync #{id}"
	`echo #{id} >> #{last_feed_id_path}`
end

def last_feed_id
	File.readlines("#{last_feed_id_path}")[-1].chomp
end