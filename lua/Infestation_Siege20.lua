/*
function CreateModelArrays(self)
    
    -- Make blobs on the ground thinner to so that Skulks and buildings aren't
    -- obscured.
    local scale = 1
    if self.coords.yAxis.y > 0.5 then
        scale = 2 -- 0.5
    end
    
    local origin = self.coords.origin

    if gInfestationQuality == "rich" then
        self.infestationModelArray = CreateInfestationModelArray( "models/alien/infestation/infestation_blob.model", self.blobCoords, origin, 1, 1 * scale )
    end
    self.infestationShellModelArray = CreateInfestationModelArray( "models/alien/infestation/infestation_shell.model", self.blobCoords, origin, 1.75, 1.25 * scale )
    
end
*/