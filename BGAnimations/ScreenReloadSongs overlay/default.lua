local function Update(self)
	self:GetChild("CurSong"):settext(SCREENMAN:GetTopScreen():GetCurSong())
	self:GetChild("CurProgress"):settext(SCREENMAN:GetTopScreen():GetProgress().."%")
end

local Reload = {
	"Tetrahol",
    --"TetraholRemastered",
}

return Def.ActorFrame{
    assert(loadfile( THEME:GetPathB("ScreenReloadSongs", "overlay/"..Reload[math.random(1,#Reload)]) ))(),
    Def.Sprite {
        Texture=THEME:GetPathG('ScreenLoadGameplayElements', 'spinner'),
        OnCommand=function(self)
            self
                :SetSize(64 * self:GetTexture():GetSourceWidth() / self:GetTexture():GetSourceHeight(), 64)
                :xy(SCREEN_LEFT + 48, SCREEN_BOTTOM - 48)
                :spin()
        end
    },
    Def.BitmapText{
        Name="CurSong",
        Font="Common Normal",
        Text="StartingUp",
        OnCommand=function(self)
            self
                :halign(0)
                :xy(SCREEN_LEFT + 100, SCREEN_BOTTOM - 60)
        end
    },
    Def.BitmapText{
        Name="CurProgress",
        Font="Common Normal",
        Text="0%",
        OnCommand=function(self)
            self
                :halign(0)
                :xy(SCREEN_LEFT + 100, SCREEN_BOTTOM - 30)
        end
    },
    OnCommand=function(self)
        self:SetUpdateFunction(Update)
    end
}
