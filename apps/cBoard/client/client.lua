-- Configurables
local modemSide = "top"
local sChan = 9999
local myChan = nil
-- Imports
os.loadAPI("/apps/cBoard/service/loginService.lua")
-- Variables
local modem = peripheral.wrap(modemSide)
if myChannel == nil then myChannel = id end
-- Main
-- Check if we're registered then log in or register.
loginService.checkUser()