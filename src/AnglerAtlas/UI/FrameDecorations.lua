local FrameDecorations = {}
local DATA = AnglerAtlas.MM:GetModule("DATA")

function FrameDecorations:Create(UIParent)
    local characterPortrait = CreateFrame("FRAME", "angler-character-portrait", UIParent)
    characterPortrait:SetSize(64, 64)
    characterPortrait:SetPoint("CENTER", UIParent, "TOPLEFT", 25, -21)
    characterPortrait.texture = characterPortrait:CreateTexture(nil,'ARTWORK')
    characterPortrait.texture:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
    characterPortrait.texture:SetAllPoints()

    characterPortrait.border = CreateFrame("FRAME", "angler-character-portrait-border", characterPortrait)
    characterPortrait.border:SetSize(63*1.28, 63*1.28)
    characterPortrait.border:SetPoint("TOPLEFT", characterPortrait, "TOPLEFT", -7.5, 1)
    characterPortrait.border.texture = characterPortrait.border:CreateTexture(nil,'ARTWORK')
    characterPortrait.border.texture:SetTexture("Interface\\FrameGeneral\\UI-Frame")
    characterPortrait.border.texture:SetAllPoints()
    characterPortrait.border.texture:SetTexCoord(0, 0.625, 0, 0.625)   

    local title = UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("LEFT", UIParent.TitleBg, "LEFT", 60, 0)
    title:SetText(DATA.textColours.gold.."Angler Atlas")
    title:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")

    local topBanner = UIParent:CreateTexture(nil,'ARTWORK')
    topBanner:SetHorizTile(true)
    topBanner:SetTexture("Interface\\COMMON\\UI-Goldborder-_tile", "REPEAT", "CLAMP", "LINEAR")
    topBanner:SetSize(855, 64)
    topBanner:SetPoint("TOP", UIParent, "TOP", -1, -23)

    return {
        characterPortrait = characterPortrait,
        title = title,
        topBanner = topBanner
    }
end

AnglerAtlas.MM:RegisterModule("FrameDecorations", FrameDecorations)