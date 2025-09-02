# great-britain-rising 💂‍♀️

Roblox project called "Great Britain Rising" game made for script team using rojo and github for version controls. To get start using check out the [Rojo documentation](https://rojo.space/docs/v7/).

> rojo serve

## Project Structure 🏗️

```
.
├── Packages -> game.ReplicatedStorage.coreShared.package
└── src/
    ├── client -> StarterPlayerScript
    ├── server -> ServerScriptService
    └── shared -> ReplicatedStorage/coreShared
        ├── controllers
        ├── database
        └── services
```

## Code snippets 📦

coreService

```lua
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

```lua
local NAME = ReplicatedStorage:WaitForChild("coreShared"):WaitForChild("packages")
```

package

```lua
local NAME = require(corePackages:WaitForChild("NAME"))
```
