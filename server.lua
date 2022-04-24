RegisterNetEvent("prop:save")
AddEventHandler("prop:save", function(prop)
  file = io.open('prop_list.txt', "a")
  io.output(file)
  local output = parseProp(prop)
  io.write(output)
  io.close(file)
end)

function printoutHeader(name)
    return "Name: `" .. name .. "` | " .. os.date("!%Y-%m-%dT%H:%M:%SZ\n{")
  end

function parseProp(prop)
    local printout = printoutHeader(prop.name)
    
    printout = printout .. "\n  \"Hash\": " .. prop.hash .. ",\n  \"Bone\": \"" .. prop.bone .. "\",\n  \"Offset\": {x: " .. prop.x ..  ", y: " .. prop.y .. ", z: " .. prop.z .. "},\n  \"Rotation\": {x: " .. prop.rotX .. ", y: " .. prop.rotY .. ", z: " .. prop.rotZ .."}"
    printout = printout .. "\n},\n\n"

    return printout
  end