require "json"

get "/ping" do
  halt 401 if !params["owner"]
  ping = Ping.find_or_create_by_owner(params["owner"])
  ping.datetime = Time.now.to_s
  ping.status = params["status"] || 0
  ping.save
  p ping
  halt 201, "OK"
end

get "/" do
  owner = params["owner"] || "4pcbr"
  @ping = Ping.owned(owner)
  status = @ping ? @ping.status.to_i : nil
  @color = :black
  if !@ping
    @color = :grey
  elsif Time.now.to_i - Time.parse(@ping.datetime).to_i > 30
    @color = :white
  elsif status == 0
    @color = :red
  elsif status == 1
    @color = :green
  end
  haml :index
end

get "/data.json" do
  owner = params["owner"] || "4pcbr"
  @ping = Ping.owned(owner) || Ping.new
  content_type :json
  @ping.profile.json.to_json
end
