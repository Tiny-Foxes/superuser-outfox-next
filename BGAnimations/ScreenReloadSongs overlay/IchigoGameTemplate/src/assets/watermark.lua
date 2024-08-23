include "gizmos"

-- main
function ready()
  do GoodBoy
    :Center()
    :basezoom(SH / IH)
    :SetSize(96, 96)
    :diffuse(1, 0.8, 0.8, 1)
    :rotationz(-45)
    :shadowcolor(0, 0, 0, 0.5)
    :shadowlengthy(3)
  end
  do Ichigo
    :Center()
    :basezoom(SH / IH)
    :SetSize(64 * Ichigo:GetTexture():GetSourceWidth() / Ichigo:GetTexture():GetSourceHeight(), 64)
  end
  do TemplateText
    :Center()
    :basezoom(SH / IH)
    :addy(96)
    :shadowcolor(0, 0, 0, 0.5)
    :shadowlengthy(3)
  end
end
function update(params)
  GoodBoy:addrotationz(30 * params.dt)
end

-- layout
GoodBoy = Rect:new()
Ichigo = Image:new("/assets/ichigo.png") -- art by draco_system
TemplateText = Label:new("Ichigo Game Template")
