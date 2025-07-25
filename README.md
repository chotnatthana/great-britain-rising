# great-britain-rising

## Code snippets

coreService

```
local NewThing = {}
NewThing.__index = NewThing

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local coreShared = ReplicatedStorage:WaitForChild("coreShared")
local coreAssets = ReplicatedStorage:WaitForChild("coreAssets")

function NewThing:init()
    print("[".. script.Parent.Name .. "][".. script.Name .. "] Initializing...")
    self:Start()
end

function NewThing:Start()
    print("[".. script.Parent.Name .. "][".. script.Name .. "] Started")
end

return NewThing
```

corePackage

```
local NAME = ReplicatedStorage:WaitForChild("coreShared"):WaitForChild("packages")
```

package

```
local NAME = require(corePackages:WaitForChild("NAME"))
```
