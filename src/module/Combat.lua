local Combat = {}


Combat.Towers = 
{
    CureBlack = {
        Blast =  function(Model: Model, Target: Model)
            local Damage = 100
            local TargetHumanoid = Target:FindFirstChild("Humanoid")
            local TargetHumanoidRootPart = Target:FindFirstChild("HumanoidRootPart")
            
            -- Access the BlastVFX from ReplicatedStorage
            local BlastVFX = game.ReplicatedStorage.VFX:FindFirstChild("CureBlackBlast")
            
            -- Create Attachments
            local Attachment1 = Instance.new("Attachment", Model["Right Arm"])
            local Attachment2 = Instance.new("Attachment", TargetHumanoidRootPart)
            
            -- Clone the BlastVFX
            local CloneVFX = BlastVFX:Clone()
            CloneVFX.Parent = Model
            
            -- Play the Blast Animation
            local BlastAnimation = TargetHumanoid:LoadAnimation(Model.Animations.BlastAnimation)
            BlastAnimation:Play()
            
            -- Set Attachments for VFX
            CloneVFX.Attachment0 = Attachment1
            CloneVFX.Attachment1 = Attachment2
            
            task.wait(3.5) -- Use wait instead of task.wait
            
            TargetHumanoid:TakeDamage(Damage)
            
            CloneVFX:Destroy()
        end

    },
}

return Combat