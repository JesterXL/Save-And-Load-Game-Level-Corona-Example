-- This file is for use with Corona(R) SDK
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
	local physics = { data =
	{ 
		
		["level1-a"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "level1-a", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   67, 115.5  ,  -68, 115.5  ,  -35, 82.5  ,  66, 85.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "level1-a", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -61, -116.5  ,  -31, -113.5  ,  -35, 82.5  ,  -68, 115.5  }
                    }
                    
                    
                    
		}
		
		, 
		["level1-b"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "level1-b", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -52, -1  ,  124.5, 28.5  ,  -125, 30.5  ,  -125, 2.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "level1-b", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   124.5, 28.5  ,  -52, -1  ,  125, -31.5  }
                    }
                    
                    
                    
		}
		
		, 
		["level1-c"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "level1-c", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   5.5, 63  ,  52.5, 123  ,  -52.5, 124  ,  -52.5, 64  }
                    }
                     ,
                    {
                    pe_fixture_id = "level1-c", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   5.5, 63  ,  9.5, -123  ,  48.5, -121  ,  52.5, 123  }
                    }
                    
                    
                    
		}
		
	} }

        -- apply scale factor
        local s = scale or 1.0
        for bi,body in pairs(physics.data) do
                for fi,fixture in ipairs(body) do
                    if(fixture.shape) then
                        for ci,coordinate in ipairs(fixture.shape) do
                            fixture.shape[ci] = s * coordinate
                        end
                    else
                        fixture.radius = s * fixture.radius
                    end
                end
        end
	
	function physics:get(name)
		return unpack(self.data[name])
	end

	function physics:getFixtureId(name, index)
                return self.data[name][index].pe_fixture_id
	end
	
	return physics;
end

return M

