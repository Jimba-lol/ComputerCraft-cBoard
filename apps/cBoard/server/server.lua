local modem = peripheral.wrap("top")
local sChannel = 9999
local logging = false
-- open listen channel
modem.open(channel)
-- list of message URIs accepted
local URIs = {
	-- user and login
	checkUser = "get",
	registerUser = "post",
	loginUser = "post"
}
-- functions
function log(message)
	print(os.time.."- "..message)
end
-- main
-- listen for the message
local event, modemSide, senderChannel, replyChannel, message, dist = os.pullEvent("modem_message")
if URIs[message.uri] == nil then return end
if (message.uri == "checkUser")
	if logging then log("Replying "..fs.exists("./data/users/").."to the following message:") end
	-- return true if computer ID is in database
	modem.transmit(message.id,senderChannel,fs.exists("./data/users/"..message.id))
elseif (message.uri == "registerUser") then
	if logging then log("Registering User ID "..message.id) end
	local h = fs.open("./data/users/"..message.id,"w")
	h.write(textutils.serialize(message.body))
	h.close()
elseif (message.uri == "loginUser") then
	local h = fs.open("./data/users/"..message.id,"r")
	local s = textutils.unserialize(h.readAll())
	local res = (message.body.username == s.username and message.body.password == s.password)
	if logging then log("Replying "..res.."to the following message:") end
	modem.transmit(message.id,senderChannel,res)
end

-- logging the message
if logging then
	log("Received message on channel: "..senderChannel)
	log("Reply channel is: "..replyChannel)
	log("The message was: "..textutils.serialize(message))
	log("the sender's distance is "..(dist or "unknown"))
end

modem.close()