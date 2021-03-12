-- Notes - need to add timeout if server takes too long to respond to requests
-- Variables
local username
local passHash
local id = os.getComputerID()
-- Functions
-- return the locally store username
function getUsername()
	return username
end
-- return the locally stored password hash
function getPassHash()
	return passHash
end
-- Clear the screen
-- Would be better in a different API honestly. Will consider moving.
local function cls() 
	term.clear()
	term.setCursorPos(1,1)
end
-- return encrypted version of string
local function encrypt(string)
	-- TODO
	return string
end
-- Listen for a reply from the cBoard server
local function listenToServer()
	local event, side, msgChannel, replyChannel, msg, dist = os.pullEvent("modem_message")
	if replyChannel == sChan then return msg end
	return listenToServer()
end
local function sendAndListen()
	modem.open(myChan)
	parallel.waitForAll(
		function() modem.transmit(sChan, myChan, myMsg) end,
		function() reply = listenToServer() end
	)
	modem.close(myChan)
	return reply
end
-- Enter credentials prompt
local function enterCreds()
	print("Please enter your Username")
	local u = read()
	print("Please enter your Password")
	local p = encrypt(read())
	return u, p
end
-- Log in to server
local function login()
	cls()
	print("Please enter your login credentials.")
	print("Please DO NOT enter a password you already use for other things, i.e. email.")
	print("Password encryption in this system is very basic and can easily be cracked.")
	local body = {}
	body.username, body.password = enterCreds()
	local myMsg = {
		uri = "loginUser",
		id = id,
		body = body
	}
	
	local reply = sendAndListen(myMsg)
	
	if reply then
		print("You're all logged in!")
		username = body.username
		passHash = body.password
		-- TODO, LMFAO WE NEED TO STORE A VAR OR SOMETHING
	elseif reply == nil then
		print("Something went wrong, server did not respond in time.")
	else
		print("Something went wrong, please try logging in again.")
		print("Press enter to continue.")
		read()
		login()
	end
end
-- Register user and computer to server
local function register()
	cls()
	print("Signup User:")
	local body = {}
	body.username, body.password = enterCreds()
	local myMsg = {
		uri = "registerUser",
		id = id,
		body = body
	}
	
	local reply = sendAndListen(myMsg)
	
	if reply then
		login()
	else
		print("Something went wrong, server did not respond in time.")
	end
end
-- check if this computer is registered on the server
local function checkUser()
	local myMsg = {
		uri = "checkUser",
		id = id
	}
	local reply = sendAndListen(myMsg)
	if reply then
		login()
	elseif reply == nil then
		print("Something went wrong, server did not respond in time.")
	else
		register()
	end
end
-- nicer entrypoint
function loginOrRegister()
	checkUser()
end