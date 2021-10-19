local defaultOptions = {
    { "NotesNum", VALUE, 1, 1, 2 },
    { "Frame", BOOL, 1 },
    { "Color", COLOR, RED },
}

local fileName = {}
fileName[1] = "/WIDGETS/StickNotes/notes1.jpg"
fileName[2] = "/WIDGETS/StickNotes/notes2.jpg"

local fileBitmap
local fileWidth
local fileHeight

local function loadBitmap(aNum)
    local filePath = fileName[aNum]
    fileBitmap = Bitmap.open(filePath)
    fileWidth, fileHeight = Bitmap.getSize(fileBitmap)
end

local function createWidget(aZone, aOptions)
    loadBitmap(aOptions.NotesNum)
    local lWidget = { zone=aZone, options=aOptions }
    return lWidget
end

local function updateWidget(aWidget, aOptions)
    loadBitmap(aOptions.NotesNum)
    aWidget.options = aOptions
end

local function refreshWidget(aWidget)
    local x = aWidget.zone.x
    local y = aWidget.zone.y
    local w = aWidget.zone.w
    local h = aWidget.zone.h

    if aWidget.options.Frame == 1 then
        lcd.setColor(CUSTOM_COLOR, aWidget.options.Color)
        lcd.drawRectangle(x, y, w, h, CUSTOM_COLOR)
        x = x + 1
        y = y + 1
        w = w - 2
        h = h - 2
    end

    if fileWidth > 0 and fileHeight > 0 then
        local scaleX = w / fileWidth
        local scaleY = h / fileHeight

        local scale = scaleX
        if scaleX > scaleY then
            scale = scaleY
        end

        local pW = fileWidth * scale
        local pH = fileHeight * scale

        local sW = w - pW
        if sW > 0 then
            sW = sW + 1
        end

        local sH = h - pH
        if sH > 0 then
            sH = sH + 1
        end

        local rX = math.floor(x + (sW/2))
        local rY = math.floor(y + (sH/2))

        scale = math.floor(scale * 100)
	    lcd.drawBitmap(fileBitmap, rX, rY, scale)
    end
end

local function backgroundWidget(aWidget)

end

return { name="StickNotes", options=defaultOptions, create=createWidget, update=updateWidget, refresh=refreshWidget, background=backgroundWidget }
