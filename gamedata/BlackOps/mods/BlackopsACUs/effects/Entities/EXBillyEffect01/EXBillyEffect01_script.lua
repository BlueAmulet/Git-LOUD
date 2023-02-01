
local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell

EXBillyEffect01 = Class(NullShell) {
    
    OnCreate = function(self)
		NullShell.OnCreate(self)
		self:ForkThread(self.EffectThread)
    end,
    
    EffectThread = function(self)
		local scale = self:GetBlueprint().Display.UniformScale
		local scaleChange = 0.30 * scale
		
		self:SetScaleVelocity(scaleChange,scaleChange,scaleChange)
		self:SetVelocity(0,0.125,0)-- Exavier Modified Velocity
		
		WaitSeconds(4)
		scaleChange = -0.01 * scale
		self:SetScaleVelocity(scaleChange,12*scaleChange,scaleChange)
		self:SetVelocity(0,1.5,0)-- Exavier Modified Velocity
		self:SetBallisticAcceleration(-0.25)-- Exavier Modified Velocity
		
		WaitSeconds(5)
		scaleChange = -0.1 * scale		
		self:SetScaleVelocity(scaleChange,scaleChange,scaleChange)	

    end,      
}

TypeClass = EXBillyEffect01

