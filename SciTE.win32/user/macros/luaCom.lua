require "luacom"

-- ######### LuaCom ########
-- ## WIN Common Object Model Support for lua 
-- ####################### 

sUrl = "http://www.yahoo.com"
luacom.config.abort_on_error = true 
luacom.config.abort_on_API_error = true 

oWeb={} -- OLE object
_oWeb = {} -- its events
	
function test_luaCom()
-- ##  Print all links from a given URL  

	sID=luacom.CLSIDfromProgID("InternetExplorer.Application")
	print("start Browser with CLSID "..sID)
-- toDo: Implement a retry here
	oWeb = luacom.CreateObject("InternetExplorer.Application") 
	assert(oWeb) 
	oWeb:Navigate(sUrl)
	oWeb.Height =300
	oWeb.Width= 650
	oWeb.Visible = true

	print ("waiting for Events")
	-- DWebBrowserEvents2: https://msdn.microsoft.com/en-us/library/aa768283(v=vs.85).aspx
	event_handler = luacom.ImplInterface(_oWeb, "InternetExplorer.Application", "DWebBrowserEvents2") 
	if event_handler == nil then  print("Error implementing Events") end 
	cookie = luacom.addConnection(oWeb, event_handler)
end

function _oWeb:NavigateComplete2(a,url) 
--	print("event NavigateComplete recieved! Url:"..url) 
end

function _oWeb:DocumentComplete(oWin,url) 
-- fires for every frame, so only react on root location complete
	  if oWeb.locationURL  == url then
			print("event DocumentComplete recieved! ")
			print("Url: "..url.." Root: "..oWeb.locationURL)
		   siteParser(oWin)
		end
end

function siteParser(oWin)
	-- gets our IHTMLDocument. We can use all listed extensions from 1-8:
	-- https://msdn.microsoft.com/en-us/library/ff975572(v=vs.85).aspx
	oDoc=oWin.Document
	
	-- using the oprional get / set prefix to access properties showed to be saver. 
	title=oDoc:gettitle()
	oDoc:settitle("myTitle")
	
	-- Now print out all links found within the Site
	eTmp=oDoc.body:getElementsByTagName("a")
	linksEnum=luacom.GetEnumerator(eTmp)
	link=linksEnum:Next()
	while link do
		print("found webblink: "..link.href)
		link=linksEnum:Next()
	end
	
	--	content=oDoc.head.innerhtml
	--	print(content)	
	oDoc=nil
	print("Fin")
end

function _oWeb:OnQuit() 
	print("event Quit recieved!") 
	oWeb=nil
	_oWeb=nil
	print("clean up ...")
	collectgarbage()
	print("Fin")
end

-- ######### run Test ###############
test_luaCom()