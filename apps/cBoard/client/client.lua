-- Imports
os.loadAPI("/apps/cBoard/client/service/loginService.lua")
-- Main
-- Check if we're registered, then log in or register.
loginService.loginOrRegister()