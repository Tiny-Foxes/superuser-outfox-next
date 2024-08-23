if Gizmo then return end

class "Gizmo" {
  __type = "Actor";
  __init = function(self, ...)
    if not ActorUtil.IsRegisteredClass(self.__type) then
      lua.ReportScriptError("Invalid Actor class \""..self.__type.."\".")
      return
    end
    self.__actor = Def[self.__type] {}
    local t = self.__type == "Sound" and ActorSound or _G[self.__type] or {}
    for k, v in pairs(Actor) do
      t[k] = v
    end
    for k, v in pairs(t) do
      self[k] = function(s, ...)
        return v(self.__actor, ...) or self.__actor
      end
    end
    self.__actor.InitCommand = function(s)
      self.__actor = s
    end
    if self.__ready then
      self:__ready(...)
    end
    table.insert(Actors, self.__actor)
  end;
  GetActor = function(self)
    return self.__actor
  end
}

class "Container" : extends "Gizmo" {
  __type = "ActorFrame";
  __ready = function(self)
    self:GetActor().FOV = 45
  end;
  AddActor = function(self, child)
    table.insert(self:GetActor(), child:GetActor())
  end;
}

class "Rect" : extends "Gizmo" {
  __type = "Quad";
}

class "Image" : extends "Gizmo" {
  __type = "Sprite";
  __ready = function(self, path)
    if path then
      self:GetActor().Texture = SRC_ROOT..path
    end
  end;
}

class "MultiImage" : extends "Gizmo" {
  __type = "ActorMultiTexture";
}

class "Label" : extends "Gizmo" {
  __type = "BitmapText";
  __ready = function(self, text, font)
    if font and font:find("/") then
      font = SRC_ROOT..font
    end
    self:GetActor().Font = font or "Common Normal"
    self:GetActor().Text = text or "Sample text"
  end;
}

class "RenderTarget" : extends "Container" {
  __type = "ActorFrameTexture";
}

class "Viewport" : extends "Gizmo" {
  __type = "ActorScreenTexture";
}

class "ShaderLoader" : extends "Gizmo" {
  __type = "Actor";
  __ready = function(self)
    if not go() then
      SCREENMAN:SystemMessage("ShaderLoader: Alpha V not detected")
      self.LoadShader = nil
    end
  end;
  LoadShader = function(self, path, name)
    local shader = Def.Actor {
      Frag = SRC_ROOT..path,
      InitCommand = function(s)
        self[name] = s:GetShader()
        s:visible(false)
      end
    }
    table.insert(ichi.Actors, 1, shader)
    return self
  end;
}

class "Model3D" : extends "Gizmo" {
  __type = "Model";
  __ready = function(self, path)
    if path then
      self:LoadMeshes(path)
      self:LoadMaterials(path)
    end
  end;
  LoadMeshes = function(self, path)
    self:GetActor().Meshes = SRC_ROOT..path
    return self
  end;
  LoadMaterials = function(self, path)
    self:GetActor().Materials = SRC_ROOT..path
    return self
  end;
}

class "Audio" : extends "Gizmo" {
  __type = "Sound";
  __ready = function(self, path)
    if path then
      self:GetActor().File = SRC_ROOT..path
      self:GetActor().Precache = true
    end
  end;
}

class "Proxy" : extends "Gizmo" {
  __type = "ActorProxy";
}

class "PlayField" : extends "Gizmo" {
  __type = "NoteField";
}

class "Polygon" : extends "Gizmo" {
  __type = "ActorMultiVertex";
}

class "AudioWaveform" : extends "Gizmo" {
  __type = "AudioVisualizer";
  __ready = function(self)
    local init = self:GetActor().InitCommand
    self:GetActor().InitCommand = function(s)
      init(s)
      s:SetSound(SCREENMAN:GetTopScreen():GetSound())
    end
    self:GetActor().UpdateRate = 1/60
  end;
}
