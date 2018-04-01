
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

BrackmanQAIHackCircuitryEffect01 = Class(EmitterProjectile) {
	FxImpactTrajectoryAligned = true,
	FxTrajectoryAligned= true,
	FxTrails = EffectTemplate.CBrackmanQAIHackCircuitryEffectFxtrailsALL[1],
}
TypeClass = BrackmanQAIHackCircuitryEffect01
