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
getPassHash()
	return passHash
end
-- Clear the screen
function cls() 
	term.clear()
	term.setCursorPos(1,1)
end
-- return encrypted version of string
function encrypt(string)
	-- TODO
	return string
end
-- Listen for a reply from the cBoard server
function ListenToServer()
	local event, side, msgChannel, replyChannel, msg, dist = os.pullEvent("modem_message")
	if replyChannel == sChan then return msg end
	return ListenToServer()
end
-- Enter credentials prompt
function enterCreds()
	print("Please enter your Username")
	local u = read()
	print("Please enter your Password")
	local p = encrypt(read())
	return u, p
end
-- Log in to server
function login()
	cls()
	print("Please enter your login credentials.")
	print("Please DO NOT enter a password you already use for other things, i.e. email.")
	print("Password encryption in this system is very basic and can easily be cracked.")
	local body = {}
	body.username, body.password = enterCreds()
	local myMsg = {
		type = "loginUser",
		id = id,
		body = body
	}
	
	modem.open(myChan)
	parallel.waitForAll(
		function() modem.transmit(sChan, myChan, myMsg) end,
		function() reply = ListenToServer() end
	)
	modem.close(myChan)
	
	if reply then
		print("You're all logged in!")
		username = body.username
		passHash = body.password
		-- TODO, LMFAO WE NEED TO STORE SOMETHING
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
function register()
	cls()
	print("Signup User:")
	local reply
	local body = {}
	body.username, body.password = enterCreds()
	local myMsg = {
		type = "registerUser",
		id = id,
		body = body
	}
	
	modem.open(myChan)
	parallel.waitForAll(
		function() modem.transmit(sChan, myChan, myMsg) end,
		function() reply = ListenToServer() end
	)
	modem.close(myChan)
	
	if reply then
		login()
	else
		print("Something went wrong, server did not respond in time.")
	end
end
-- check if this computer is registered on the server
function checkUser()
	local reply
	local myMsg = {}
	myMsg.type = "checkUser"
	myMsg.id = id
	
	modem.open(myChan)
	parallel.waitForAll(
		function() modem.transmit(sChan, myChan, myMsg) end,
		function() reply = ListenToServer() end
	)
	modem.close(myChan)
	
	if reply then
		login()
	elseif reply == nil then
		print("Something went wrong, server did not respond in time.")
	else
		register()
	end
end