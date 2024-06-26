-- This file is the initial pass for debugging PhxWeapDPS
-- all BP files are scanned, DPS and threat is calcualted on a per weapon basis
-- and output to outputFileName
local outputFileName = "output_fullSSwThreat.csv"

-- Threat Balance Constants
-- see: https://docs.google.com/document/d/1oMpHiHDKjTID0szO1mvNSH_dAJfg0-DuZkZAYVdr-Ms/edit
local SpeedT2_KNIFE = 3.1058
local RangeT2_KNIFE = 25
local RangeAvgEngage = 50
local tEnd = 13.0

local dirtree = require('dirtree')
local cleanUnitName = require('PhxLib').cleanUnitName
local getTechLevel = require('PhxLib').getTechLevel
local getVision = require('PhxLib').getVision
local calcUnitDPS = require('PhxLib').calcUnitDPS

local allBlueprints = {}
local curBlueprint = {}
local allShortIDs = {}
local allFullDirs = {}
local countBPs = 0
local countFiles = 0

function UnitBlueprint(bp)
    -- Helper function that replaces the SCFA function UnitBlueprint() and
    --   instead concatinates all BPs into "allBlueprints"
    -- Required Globals (bad practice I know, but kludge.)
    --    curBlueprint
    --    allBlueprints
    countBPs = countBPs + 1
    table.insert(allBlueprints, bp)
    curBlueprint = bp
end

function Sound(list)
    -- Helper function that replaces the SCFA function Sound()
    return list
end

-- Initial loop that finds and runs each BP file in the path given
-- This will generate the following:
--   allBlueprints - a single table with all BPs in it.
--   allShortIDs - a table of UnitIDSs for all BPs
--   allFullDirs - a table of full directory path to each BP
local baseFolder = "../../gamedata"
print("Reading blueprints...")
print("Scanning all folders in " .. baseFolder)
for filename, attr in dirtree("../../gamedata/") do
    if string.find(filename, '.*/units/.*_unit%.bp') then
        -- filename = "./modDir/units/UAL0402_unit.bp"

        --print("Found Matching File:", filename)
        UnitBaseName = string.match(filename, '[%a%d]*_unit%.bp$')
        -- UnitBaseName = "UAL0402_unit.bp"

        local strStrt = 1
        local strStop = string.find(UnitBaseName,"[_%.]") - 1 --Find first _ or .
        UnitBaseName = string.sub(UnitBaseName,strStrt,strStop)
        -- UnitBaseName = "UAL0402"

        --print(UnitBaseName)
        countFiles = countFiles + 1
        dofile(filename)
        table.insert(allShortIDs, UnitBaseName)
        table.insert(allFullDirs, filename)

        local BPnum = 1
        while (countFiles ~= countBPs) do
            table.insert(allShortIDs, UnitBaseName .. "_" .. BPnum)
            table.insert(allFullDirs, filename)
            countFiles = countFiles + 1
            BPnum = BPnum + 1
        end 

    end

end

print("...Phx DPS and Threat Run Beginning...")
local file = io.open(outputFileName, "w+")
io.output(file)
io.write(
                "ID" 
                .. "," .. "Unit Name"
                .. "," .. "Tier"
                .. "," .. "Type"
                .. "," .. "Type2"
                .. "," .. "Race"
                .. "," .. "Chassis"
                .. "," .. "ThreatSpd"
                .. "," .. "ThreatRange"
                .. "," .. "ThreatDam"
                .. "," .. "ThreatHP"
                .. "," .. "ThreatTotal"
                .. "," .. "tSurfDPS"
                .. "," .. "tSubDPS"
                .. "," .. "tAirDPS"
                .. "," .. "totDPS"
                .. "," .. "maxRange"
                .. "," .. "Vision"
                .. "," .. "Shield"
                .. "," .. "Health"
                .. "," .. "Mass"
                .. "," .. "Energy"
                .. "," .. "BuildTime"
                .. "," .. "Speed"
                .. "," .. "Warnings"
                .. "\n"
            )

for curBPid,curBP in ipairs(allBlueprints) do
    local curShortID = (allShortIDs[curBPid] or "None")

    local Mass = 0
    local Energy = 0
    local BuildTime = 0
    local Tier = 0
    local Vision = 0
    local Race = 'none'

    local unitDPS = calcUnitDPS(curBP,curShortID)   

    -- Get Economic values for Mass Energy and BuildTime if they exist
    if curBP.Economy then
        Energy = curBP.Economy.BuildCostEnergy or 0
        Mass = curBP.Economy.BuildCostMass or 0
        BuildTime = curBP.Economy.BuildCostMass or 0
    else 
        Energy = 0
        Mass = 0
        BuildTime = 0
    end

    Tier = getTechLevel(curBP)
    Vision = getVision(curBP)

    if curBP.General and curBP.General.FactionName then 
        Race = curBP.General.FactionName
    end
    
    --Record Unit Stats to output file
    io.write(
        curShortID 
        .. "," .. cleanUnitName(curBP)
        .. "," .. Tier
        .. "," .. "Type"
        .. "," .. "Type2"
        .. "," .. Race
        .. "," .. "Chassis"
        .. "," .. unitDPS.Threat.Speed
        .. "," .. unitDPS.Threat.Range
        .. "," .. unitDPS.Threat.Dam
        .. "," .. unitDPS.Threat.HP
        .. "," .. unitDPS.Threat.Total
        .. "," .. unitDPS.srfDPS
        .. "," .. unitDPS.subDPS
        .. "," .. unitDPS.airDPS
        .. "," .. unitDPS.totDPS
        .. "," .. unitDPS.maxRange
        .. "," .. Vision
        .. "," .. unitDPS.Shield
        .. "," .. unitDPS.Health
        .. "," .. Mass
        .. "," .. Energy
        .. "," .. BuildTime
        .. "," .. unitDPS.Speed
        .. "," .. unitDPS.Warn
        .. "\n"
    )
end -- Blueprint for() Loop

io.close(file)
