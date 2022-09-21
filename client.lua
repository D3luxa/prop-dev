local enableProp  = false
local object = nil
local canMove = false
local bone = nil
local propLabel = nil

local x = 0.00
local y = 0.00
local z = 0.00

local rotX = 0.00
local rotY = 0.00
local rotZ = 0.00

RegisterNetEvent('prop:attachProp', function(prop, bone)
    if createdProp ~= nil then
      TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(161, 43, 43, 0.9); border-radius: 5px;"> <b>{0}</b></div>',
          args = {"Already created!"}
      })

      return
    end

    attachProp(prop, bone)

    enableProp = true
end)

-- Functions
function attachProp(prop, bone)
  CreateThread(function()
    while enableProp do
      Wait(10)

      object = CreateObject(GetHashKey(prop), 0, 0, 0, true, true, true) 
      result = AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), bone), x, y, z, rotX, rotY, rotZ, true, true, false, true, 1, true)
      canMove = true
      rotate(bone)
      return result
    end
  end)
end

function rotate(bone)
  CreateThread(function()
    while canMove do
      Wait(0)

      DisableControlAction(0, 172, true) -- ARROW UP - X UP
      DisableControlAction(0, 173, true) -- ARROW DOWN - X DOWN
      DisableControlAction(0, 174, true) -- ARROW LEFT - Y UP
      DisableControlAction(0, 175, true) -- ARROW RIGHT - Y DOWN
      DisableControlAction(0, 15, true) -- SCROLLWHEEL UP
      DisableControlAction(0, 14, true) -- SCROLLWHEEL DOWN
      DisableControlAction(0, 159, true) -- NUM 6
      DisableControlAction(0, 161, true) -- NUM 7
      DisableControlAction(0, 162, true) -- NUM 8
      DisableControlAction(0, 163, true) -- NUM 9
      DisableControlAction(0, 244, true) -- NUM M
      DisableControlAction(0, 306, true) -- NUM N

      speed = 0.01
      DisableControlAction(0, 21, true) -- 	LEFT SHIFT
      if IsDisabledControlPressed(0, 21) then -- SHIFT hold down
        speed = 0.10
      end

      var = 5.00
      DisableControlAction(0, 36, true)
      if IsDisabledControlPressed(0, 36) then -- ctrl held down
        var = 1.00
      end

      if IsDisabledControlJustPressed(0, 172) then -- UP
        x = x - speed
        print(x)
      elseif IsDisabledControlJustPressed(0, 173) then -- DOWN
        x = x + speed
        print(x)
      elseif IsDisabledControlJustPressed(0, 174) then -- LEFT
        y = y + speed
        print(y)
      elseif IsDisabledControlJustPressed(0, 175) then -- RIGHT
        y = y - speed
        print(y)
      elseif IsDisabledControlJustPressed(0, 244) then -- UP
        z = z + speed
        print(z)
      elseif IsDisabledControlJustPressed(0, 306) then -- DOWN
        z = z - speed
        print(z)
      elseif IsDisabledControlJustPressed(0, 15) then -- SCROLLWHEEL UP
        rotX = rotX - var
        print(rotX)
      elseif IsDisabledControlJustPressed(0, 14) then -- SCROLLWHEEL DOWN
        rotX = rotX + var
        print(rotX)
      elseif IsDisabledControlJustPressed(0, 159) then -- NUM 6
        rotZ = rotZ - var
        print(rotZ)
      elseif IsDisabledControlJustPressed(0, 161) then -- NUM 7
        rotZ = rotZ + var
        print(rotZ)
      elseif IsDisabledControlJustPressed(0, 162) then -- NUM 8
        rotY = rotY - var
        print(rotY)
      elseif IsDisabledControlJustPressed(0, 163) then -- NUM 9
        rotY = rotY + var
        print(rotY)
      end
      AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), bone), x, y, z, rotX, rotY, rotZ, true, true, false, true, 1, true)

    end
  end)
end

function dettachProp(prop)
  enableProp = false
  DetachEntity(prop, 1, true)
  DeleteObject(prop)
  DeleteEntity(prop)
  canMove = false

  x = 0.00
  y = 0.00
  z = 0.00

  rotX = 0.00
  rotY = 0.00
  rotZ = 0.00
end

function finish()
  if enableProp then
    TriggerServerEvent('prop:save', {
      name= propLabel, 
      hash=GetHashKey(object), 
      bone=bone, 
      x=x, 
      y=y, 
      z=z, 
      rotX=rotX,
      rotY = rotY,
      rotZ = rotZ
    })

    TriggerEvent('chat:addMessage', {
      template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(53, 43, 161, 0.9); border-radius: 5px;"> <b>{0}</b></div>',
        args = {"Check main folder prop_list.txt file!"}
    })
  end
end

-- Menu
function GetUserInput(windowTitle, defaultText, maxInputLength)
  -- Create the window title string.
  local resourceName = string.upper(GetCurrentResourceName())
  local textEntry = resourceName .. "_WINDOW_TITLE"
  if windowTitle == nil then
    windowTitle = "Enter:"
  end
  AddTextEntry(textEntry, windowTitle)

  -- Display the input box.
  DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
  Wait(0)
  -- Wait for a result.
  while true do
    local keyboardStatus = UpdateOnscreenKeyboard();
    if keyboardStatus == 3 then -- not displaying input field anymore somehow
      return nil
    elseif keyboardStatus == 2 then -- cancelled
      return nil
    elseif keyboardStatus == 1 then -- finished editing
      return GetOnscreenKeyboardResult()
    else
      Wait(0)
    end
  end
end

-- Commands
RegisterCommand('prop', function(src, args)
  propLabel = args[1]
  
  if propLabel == nil then
      TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(161, 43, 43, 0.9); border-radius: 5px;"> <b>{0}</b></div>',
          args = {"SYSTEM: Prop need to be string"}
      })
      return
  end

  if #args >= 2 then 
      bone = args[2]
  end

  if bone == nil or bone == "" then
      TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(161, 43, 43, 0.9); border-radius: 5px;"> <b>{0}</b></div>',
          args = {"Bone need to be number"}
      })
      return
  end

  TriggerEvent('prop:attachProp', propLabel, bone, args)
end)

RegisterCommand("dettach", function()
  dettachProp(object)
end)

RegisterCommand('propfinish', function()
  finish()
  dettachProp(object)
end)
