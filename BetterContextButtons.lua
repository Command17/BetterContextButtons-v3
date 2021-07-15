--[[
### API

## Create a new button

```lua
local BetterContextButtons = require(game:GetService("ReplicatedStorage").BetterContextButtons)

local ButtonName = BetterContextButtons.new() --or BetterContextButtons.New()
```

## Button down or button up

```lua
ButtonName.Button1Down:Connect(function()
     print(string.format("%s pressed the button 1 down!", game:GetService("Players").LocalPlayer.Name))
end)
```

```lua
ButtonName.Button1Up:Connect(function()
     print(string.format("%s pressed the button 1 up!", game:GetService("Players").LocalPlayer.Name))
end)
```

## Bind and UnBind

Bind makes a button visible!

```lua
ButtonName:Bind()
```

UnBind makes a button not visible anymore!

```lua
ButtonName:Unbind() --or ButtonName:UnBind()
```

## Remove a button

Destroys the button.

```lua
ButtonName:destroy() --or ButtonName:Destroy()
```

## Set the name of a button

```lua
ButtonName:SetName("Name here")
```

## Set the position of a button

```lua
ButtonName:SetPosition(UDim2.new(position here)) --Plus anchor point 0.5, 0.5
```

## Set the size of a button

```lua
ButtonName:SetSize(UDim2.new(size here))
```

## Set the label of a button

```lua
ButtonName:SetLabel("text here")
```

## Set the image of a button

```lua
ButtonName:SetImage("rbxassetid://idhere")
```

## Set the theme for the buttons

```lua
BetterContextButtons:SetTheme("theme name")
```

]]--

local Maid = require(script.Maid)
local Signal = require(script.Signal)
local Theme = require(script.Theme)
local CurrentTheme = Theme("Default")
local BetterContextButtons = {}
BetterContextButtons.__index = BetterContextButtons

-- PRIVATE FUNCTIONS --

local function CheckUDim2(handler)
	if not typeof(handler) == "UDim2" then
		error(string.format("UDim2 expected got %s", typeof(handler)))
	end
end

function BetterContextButtons:__Gui()
	self.Gui = Instance.new("ScreenGui")
	self.Gui.Name = "BetterContextButtons"
	self.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") or game.Players.LocalPlayer:FindFirstChild("PlayerGui")
	self.Gui.ResetOnSpawn = false
end

BetterContextButtons:__Gui()

-- PLUBIC FUNCTIONS --

function BetterContextButtons.new()
	local self = {}
	local maid = Maid.new()
	setmetatable(self, BetterContextButtons)
	assert(game:GetService("RunService"):IsClient(), "BetterContextButtons cannot be called from the server, nil or false.")
	
	local ImageButton = Instance.new("ImageButton", self.Gui)
	ImageButton.Image = CurrentTheme.ImageId
	ImageButton.ImageRectOffset = Vector2.new(1, 1)
	ImageButton.ImageRectSize = Vector2.new(144, 144)
	ImageButton.SliceScale = 1
	ImageButton.ScaleType = Enum.ScaleType.Stretch
	ImageButton.Size = UDim2.new(0,74,0,74)
	ImageButton.BackgroundTransparency = 1
	ImageButton.ImageColor3 = CurrentTheme.NormalColor
	ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageButton.Visible = false

	ImageButton.Name = "Unnamed"

	self.Button = ImageButton
	self._maid = maid
	
	self.Button1Down = Signal.new("Button1Down")
	self.Button1Up = Signal.new("Button1Up")
	
	self._maid:GiveTask(self.Button1Down)
	self._maid:GiveTask(self.Button1Up)
	
	return self
end

function BetterContextButtons:Bind()
	self.Button.Visible = true
	
	self.Button.MouseButton1Down:Connect(function()
		self.Button.ImageColor3 = CurrentTheme.ClickedColor
		self.Button1Down:Fire()
	end)
	self.Button.MouseButton1Up:Connect(function()
		self.Button.ImageColor3 = CurrentTheme.NormalColor
		self.Button1Up:Fire()
	end)
	self.Button.TouchLongPress:Connect(function(pos, state)
		local start = state == Enum.UserInputState.Begin
		if state == start then
			self.Button.ImageColor3 = CurrentTheme.ClickedColor
			self.Button1Down:Fire()
		else
			self.Button.ImageColor3 = CurrentTheme.NormalColor
			self.Button1Up:Fire()
		end
	end)
end

function BetterContextButtons:Unbind()
	self.Button.Visible = false
end

function BetterContextButtons:UnBind()
	BetterContextButtons:Unbind()
end

function BetterContextButtons:SetName(Name: string)
	self.Button.Name = Name
end

function BetterContextButtons:SetPosition(Pos)
	CheckUDim2(Pos)
	self.Button.Position = Pos
end

function BetterContextButtons:SetSize(Size)
	CheckUDim2(Size)
	self.Button.Size = Size
end

function BetterContextButtons:SetLabel(Text: string)
	local Label = Instance.new("TextLabel", self.Button)
	Label.Text = Text
	Label.Font = Enum.Font.GothamBlack
	Label.Size = self.Button.Size
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1
	Label.TextScaled = true
end

function BetterContextButtons:SetImage(url: string)
	local Image = Instance.new("ImageLabel", self.Button)
	Image.Size = self.Button.Size
	Image.BackgroundTransparency = 1
	Image.Image = url
end

function BetterContextButtons:SetTheme(theme: string)
	CurrentTheme = Theme(theme)
end

function BetterContextButtons:destroy()
	self.Button:Destroy()
	self._maid:DoCleaning() 
end

BetterContextButtons.Destroy = BetterContextButtons.destroy
BetterContextButtons.New = BetterContextButtons.new

return BetterContextButtons
