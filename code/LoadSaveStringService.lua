local LoadSaveStringService = {}
LoadSaveStringService.FILE_NAME = "progress.json"
LoadSaveStringService.DIRECTORY = system.DocumentsDirectory

function LoadSaveStringService:new()

	local service = {}

	function service:save(string)
		-- create a file path for corona i/o
		local path = system.pathForFile(LoadSaveStringService.FILE_NAME, LoadSaveStringService.DIRECTORY)
		assert(path ~= nil, "path is nil")

		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "w" )
		--print("base: ", base, ", path: ", path, ", file: ", file)
		file:write(string)
		io.close( file )	-- close the file after using it
		return true
	end

	function service:load()
		-- create a file path for corona i/o
		local path = system.pathForFile(LoadSaveStringService.FILE_NAME, LoadSaveStringService.DIRECTORY)
		assert(path ~= nil, "path is nil")
		-- will hold contents of file
		local contents

		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "r" )
		if file then
			contents = file:read( "*a" )
			io.close( file )	-- close the file after using it
			if contents == nil then return nil end
			return contents
		else
			return nil
		end
	end

	function service:delete()
		local path = system.pathForFile(LoadSaveStringService.FILE_NAME, LoadSaveStringService.DIRECTORY)
		return os.remove(path)
	end

	return service
end

return LoadSaveStringService
