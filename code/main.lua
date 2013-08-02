display.setStatusBar( display.HiddenStatusBar )

require("physics")
stage = display.getCurrentStage()
physics.setDrawMode("hybrid")
-- physics.setDrawMode("normal")
physics.start()
physics.setGravity(0, 9.8)

_G.mainGroup = display.newGroup()
_G.currentLevel = nil
_G.currentLevelName = nil
_G.score = 0

function getMetalSphere(r)
	local sphere = display.newCircle(0, 0, r)
	mainGroup:insert(sphere)
	physics.addBody(sphere, "dynamic", {density=3, radius=r, bounce=0.0, friction=0.7})
	return sphere
end

local scoreText = display.newText("0", stage.width - 60, 4, system.nativeFont, 21)

function increaseScore()
	score = score + 12
	scoreText.text = tostring(score)
end

function setScore(value)
	score = value
	scoreText.text = tostring(score)
end

local sphere = getMetalSphere(20)
function sphere:reset()
	sphere.x = 100
	sphere.y = 200
end
function sphere:getMemento()
	return {x=self.x, y=self.y}
end
function sphere:setMemento(memento)
	self.x = memento.x
	self.y = memento.y
end	
sphere:reset()

local function startDrag( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		increaseScore()
		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
		
		-- Make body type temporarily "kinematic" (to avoid gravitional forces)
		event.target.bodyType = "kinematic"
		
		-- Stop current motion, if any
		event.target:setLinearVelocity( 0, 0 )
		event.target.angularVelocity = 0

	elseif t.isFocus then
		if "moved" == phase then
			t.x = event.x - t.x0
			t.y = event.y - t.y0

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			t.bodyType = "dynamic"
		end
	end

	-- Stop further propagation of touch event!
	return true
end

sphere:addEventListener("touch", startDrag)

-- timer.performWithDelay( 1, function(e)
-- 	mainGroup.x = mainGroup.x - 1
-- 	end, 0)

local function loadLevel(level)

	if _G.currentLevelName == "level1" then
		destroyLevel1()
	elseif _G.currentLevelName == "level2" then
		destroyLevel2()
	end

	_G.currentLevelName = level

	mainGroup.x = 0
	if level == "level1" then
		buildLevel1()
	elseif level == "level2" then
		buildLevel2()
	end

	sphere:reset()
	startGame()
end

local function getFloor(name, physicsData)
	if x == nil then x = 0 end
	if y == nil then y = 0 end
	local floor = display.newImage(name .. ".png", true)
	floor:setReferencePoint(display.TopLeftReferencePoint)
	mainGroup:insert(floor)
	physics.addBody(floor, "static", physicsData:get(name) )
	return floor
end

function buildLevel1()
	local level1PhysicsData = (require "level1").physicsData(1.0)

	local floorA = getFloor("level1-a", level1PhysicsData)
	local floorB = getFloor("level1-b", level1PhysicsData)
	local floorC = getFloor("level1-c", level1PhysicsData)

	floorB.x = floorA.x + floorA.width - 4
	floorB.y = floorA.y + floorA.height - 64

	floorC.x = floorB.x + floorB.width - 4
	floorC.y = floorB.y - 188

	currentLevel = {}
	currentLevel.floorA = floorA
	currentLevel.floorB = floorB
	currentLevel.floorC = floorC
end

function destroyLevel1()
	if currentLevel == nil then return true end

	physics.removeBody(currentLevel.floorA)
	physics.removeBody(currentLevel.floorB)
	physics.removeBody(currentLevel.floorC)

	currentLevel.floorA:removeSelf()
	currentLevel.floorB:removeSelf()
	currentLevel.floorC:removeSelf()

	currentLevel = nil
end

function buildLevel2()
	local level2PhysicsData = (require "level2").physicsData(1.0)

	local floorA = getFloor("level2-a", level2PhysicsData)
	local floorB = getFloor("level2-b", level2PhysicsData)
	local floorC = getFloor("level2-c", level2PhysicsData)
	local floorD = getFloor("level2-d", level2PhysicsData)

	floorB.x = floorA.x + floorA.width - 4
	floorB.y = floorA.y + floorA.height - 106

	floorC.x = floorB.x + floorB.width - 8
	floorC.y = floorB.y + 34


	floorD.x = floorC.x + floorC.width - 20
	floorD.y = floorD.y + 1

	currentLevel = {}
	currentLevel.floorA = floorA
	currentLevel.floorB = floorB
	currentLevel.floorC = floorC
	currentLevel.floorD = floorD
end

function destroyLevel2()
	if currentLevel == nil then return true end

	physics.removeBody(currentLevel.floorA)
	physics.removeBody(currentLevel.floorB)
	physics.removeBody(currentLevel.floorC)
	physics.removeBody(currentLevel.floorD)

	currentLevel.floorA:removeSelf()
	currentLevel.floorB:removeSelf()
	currentLevel.floorC:removeSelf()
	currentLevel.floorD:removeSelf()

	currentLevel = nil
end

function getLevelMemento()
	return {levelName = _G.currentLevelName, x=mainGroup.x}
end

function setLevelMemento(memento)
	loadLevel(memento.levelName)
	mainGroup.x = memento.x
end

function getGameMemento()
	local gameSave = {}
	gameSave.sphereMemento = sphere:getMemento()
	gameSave.levelMemento = getLevelMemento()
	gameSave.score = score
	return gameSave 
end

function setGameMemento(memento)
	setLevelMemento(memento.levelMemento)
	sphere:setMemento(memento.sphereMemento)
	setScore(memento.score)
end

function saveGame()
	local gameSaveMemento = getGameMemento()
	local json = require "json"
	local jsonString = json.encode(gameSaveMemento)
	saveStringToFile(jsonString)
end

function loadGame()
	local jsonString = readSaveStringFromFile()
	local json = require "json"
	local gameSaveMemento = json.decode(jsonString)
	setGameMemento(gameSaveMemento)
end

function startGame()
	killGameTimer()
	gameTimerID = timer.performWithDelay(1, runGame, 0)
end

function runGame()
	mainGroup.x = mainGroup.x - 2
	if _G.currentLevelName == "level1" and mainGroup.x <= -400 then
		endGame()
	elseif _G.currentLevelName == "level2" and mainGroup.x <= -700 then
		endGame()
	end
end

function killGameTimer()
	if gameTimerID then
		timer.cancel(gameTimerID)
	end
end

function endGame()
	killGameTimer()
	if _G.currentLevelName == "level1" then
		loadLevel("level2")
	end
end

function saveStringToFile(jsonString)
	local LoadSaveStringService = require "LoadSaveStringService"
	local service = LoadSaveStringService:new()
	service:save(jsonString)
end

function readSaveStringFromFile()
	local LoadSaveStringService = require "LoadSaveStringService"
	local service = LoadSaveStringService:new()
	local jsonString = service:load()
	return jsonString
end

function onSaveButtonTouched()
	saveGame()
end

function onLoadButtonTouched()
	loadGame()
end

widget = require "widget"
local saveButton = widget.newButton
{
    left = 100,
    top = 300,
    width = 150,
    height = 50,
    id = "saveButton",
    label = "Save Level",
    onEvent = onSaveButtonTouched,
}

local loadButton = widget.newButton
{
    left = 100,
    top = 360,
    width = 150,
    height = 50,
    id = "loadButton",
    label = "Load Level",
    onEvent = onLoadButtonTouched,
}

loadLevel("level1")

-- timer.performWithDelay(2000, function(e)loadLevel("level2") end)
