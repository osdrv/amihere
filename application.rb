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
  p @ping
  if !@ping
    @color = :grey
  elsif Time.now.to_i - Time.parse(@ping.datetime).to_i > 30
    @color = :white
  elsif @ping.status == 0
    @color = :red
  else
    @color = :green
  end
  haml :index
end
