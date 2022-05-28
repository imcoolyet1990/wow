
local assets = {6183930112, 6071575925, 6071579801, 6073763717, 3570695787, 5941353943, 4155801252, 2454009026, 5553946656, 4155801252, 4918373417, 3570695787, 2592362371}
local cprovider = Game:GetService"ContentProvider"
for _, v in next, assets do
	cprovider:Preload("rbxassetid://" .. v)
end

repeat wait() until game:IsLoaded()

-- the rewrite was lost, this was the latest version of uwuware I could find
-- last time this was modified before being discontinued was around October 2021, so most of this shit's probably obsolete (USE AT YOUR OWN RISK!!!)
-- there are a lot of shitty methods here that were never cleaned up, a lot of shitty organization and shitty code in general
-- anyway, enjoy trying to make sense out of any of this


-- if you're just looking to get the library for whatever reason, just copy everything from below till you see LIBRARY END

	--LIBRARY START
	--Services
	getgenv().runService = game:GetService"RunService"
	getgenv().textService = game:GetService"TextService"
	getgenv().inputService = game:GetService"UserInputService"
	getgenv().tweenService = game:GetService"TweenService"

	if getgenv().library then
		getgenv().library:Unload()
	end

	local library = {design = getgenv().design == "kali" and "kali" or "uwuware", tabs = {}, draggable = true, flags = {}, title = "uwuware", open = false, mousestate = inputService.MouseIconEnabled, popup = nil, instances = {}, connections = {}, options = {}, notifications = {}, tabSize = 0, theme = {}, foldername = "uw_configs", fileext = ".uw"}
	getgenv().library = library

	--Locals
	local dragging, dragInput, dragStart, startPos, dragObject

	local blacklistedKeys = { --add or remove keys if you find the need to
		Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Escape
	}
	local whitelistedMouseinputs = { --add or remove mouse inputs if you find the need to
		Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton2,Enum.UserInputType.MouseButton3
	}

	--Functions
	library.round = function(num, bracket)
		if typeof(num) == "Vector2" then
			return Vector2.new(library.round(num.X), library.round(num.Y))
		elseif typeof(num) == "Vector3" then
			return Vector3.new(library.round(num.X), library.round(num.Y), library.round(num.Z))
		elseif typeof(num) == "Color3" then
			return library.round(num.r * 255), library.round(num.g * 255), library.round(num.b * 255)
		else
			return num - num % (bracket or 1);
		end
	end

	--From: https://devforum.roblox.com/t/how-to-create-a-simple-rainbow-effect-using-tweenService/221849/2
	local chromaColor
	spawn(function()
		while library and wait() do
			chromaColor = Color3.fromHSV(tick() % 6 / 6, 1, 1)
		end
	end)

	function library:Create(class, properties)
		properties = properties or {}
		if not class then return end
		local a = class == "Square" or class == "Line" or class == "Text" or class == "Quad" or class == "Circle" or class == "Triangle"
		local t = a and Drawing or Instance
		local inst = t.new(class)
		for property, value in next, properties do
			inst[property] = value
		end
		table.insert(self.instances, {object = inst, method = a})
		return inst
	end

	function library:AddConnection(connection, name, callback)
		callback = type(name) == "function" and name or callback
		connection = connection:connect(callback)
		if name ~= callback then
			self.connections[name] = connection
		else
			table.insert(self.connections, connection)
		end
		return connection
	end

	function library:Unload()
		inputService.MouseIconEnabled = self.mousestate
		for _, c in next, self.connections do
			c:Disconnect()
		end
		for _, i in next, self.instances do
			if i.method then
				pcall(function() i.object:Remove() end)
			else
				i.object:Destroy()
			end
		end
		for _, o in next, self.options do
			if o.type == "toggle" then
				coroutine.resume(coroutine.create(o.SetState, o))
			end
		end
		library = nil
		getgenv().library = nil
	end

	function library:LoadConfig(config)
		if table.find(self:GetConfigs(), config) then
			local Read, Config = pcall(function() return game:GetService"HttpService":JSONDecode(readfile(self.foldername .. "/" .. config .. self.fileext)) end)
			Config = Read and Config or {}
			for _, option in next, self.options do
				if option.hasInit then
					if option.type ~= "button" and option.flag and not option.skipflag then
						if option.type == "toggle" then
							spawn(function() option:SetState(Config[option.flag] == 1) end)
						elseif option.type == "color" then
							if Config[option.flag] then
								spawn(function() option:SetColor(Config[option.flag]) end)
								if option.trans then
									spawn(function() option:SetTrans(Config[option.flag .. " Transparency"]) end)
								end
							end
						elseif option.type == "bind" then
							spawn(function() option:SetKey(Config[option.flag]) end)
						else
							spawn(function() option:SetValue(Config[option.flag]) end)
						end
					end
				end
			end
		end
	end

	function library:SaveConfig(config)
		local Config = {}
		if table.find(self:GetConfigs(), config) then
			Config = game:GetService"HttpService":JSONDecode(readfile(self.foldername .. "/" .. config .. self.fileext))
		end
		for _, option in next, self.options do
			if option.type ~= "button" and option.flag and not option.skipflag then
				if option.type == "toggle" then
					Config[option.flag] = option.state and 1 or 0
				elseif option.type == "color" then
					Config[option.flag] = {option.color.r, option.color.g, option.color.b}
					if option.trans then
						Config[option.flag .. " Transparency"] = option.trans
					end
				elseif option.type == "bind" then
					if option.key ~= "none" then
						Config[option.flag] = option.key
					end
				elseif option.type == "list" then
					Config[option.flag] = option.value
				else
					Config[option.flag] = option.value
				end
			end
		end
		writefile(self.foldername .. "/" .. config .. self.fileext, game:GetService"HttpService":JSONEncode(Config))
	end

	function library:GetConfigs()
		if not isfolder(self.foldername) then
			makefolder(self.foldername)
			return {}
		end
		local files = {}
		local a = 0
		for i,v in next, listfiles(self.foldername) do
			if v:sub(#v - #self.fileext + 1, #v) == self.fileext then
				a = a + 1
				v = v:gsub(self.foldername .. "\\", "")
				v = v:gsub(self.fileext, "")
				table.insert(files, a, v)
			end
		end
		return files
	end

	library.createLabel = function(option, parent)
		option.main = library:Create("TextLabel", {
			LayoutOrder = option.position,
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -12, 0, 24),
			BackgroundTransparency = 1,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Parent = parent
		})

		setmetatable(option, {__newindex = function(t, i, v)
			if i == "Text" then
				option.main.Text = tostring(v)
				option.main.Size = UDim2.new(1, -12, 0, textService:GetTextSize(option.main.Text, 15, Enum.Font.Code, Vector2.new(option.main.AbsoluteSize.X, 9e9)).Y + 6)
			end
		end})
		option.Text = option.text
	end

	library.createDivider = function(option, parent)
		option.main = library:Create("Frame", {
			LayoutOrder = option.position,
			Size = UDim2.new(1, 0, 0, 18),
			BackgroundTransparency = 1,
			Parent = parent
		})

		library:Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -24, 0, 1),
			BackgroundColor3 = Color3.fromRGB(60, 60, 60),
			BorderColor3 = Color3.new(),
			Parent = option.main
		})

		option.title = library:Create("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			TextColor3 =  Color3.new(1, 1, 1),
			TextSize = 15,
			Font = Enum.Font.Code,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = option.main
		})

		setmetatable(option, {__newindex = function(t, i, v)
			if i == "Text" then
				if v then
					option.title.Text = tostring(v)
					option.title.Size = UDim2.new(0, textService:GetTextSize(option.title.Text, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 12, 0, 20)
					option.main.Size = UDim2.new(1, 0, 0, 18)
				else
					option.title.Text = ""
					option.title.Size = UDim2.new()
					option.main.Size = UDim2.new(1, 0, 0, 6)
				end
			end
		end})
		option.Text = option.text
	end

	library.createToggle = function(option, parent)
		option.hasInit = true

		option.main = library:Create("Frame", {
			LayoutOrder = option.position,
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Parent = parent
		})

		local tickbox
		local tickboxOverlay
		if option.style then
			tickbox = library:Create("ImageLabel", {
				Position = UDim2.new(0, 6, 0, 4),
				Size = UDim2.new(0, 12, 0, 12),
				BackgroundTransparency = 1,
				Image = "rbxassetid://3570695787",
				ImageColor3 = Color3.new(),
				Parent = option.main
			})

			library:Create("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, -2, 1, -2),
				BackgroundTransparency = 1,
				Image = "rbxassetid://3570695787",
				ImageColor3 = Color3.fromRGB(60, 60, 60),
				Parent = tickbox
			})

			library:Create("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, -6, 1, -6),
				BackgroundTransparency = 1,
				Image = "rbxassetid://3570695787",
				ImageColor3 = Color3.fromRGB(40, 40, 40),
				Parent = tickbox
			})

			tickboxOverlay = library:Create("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, -6, 1, -6),
				BackgroundTransparency = 1,
				Image = "rbxassetid://3570695787",
				ImageColor3 = library.flags["Menu Accent Color"],
				Visible = option.state,
				Parent = tickbox
			})

			library:Create("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = "rbxassetid://5941353943",
				ImageTransparency = 0.6,
				Parent = tickbox
			})

			table.insert(library.theme, tickboxOverlay)
		else
			tickbox = library:Create("Frame", {
				Position = UDim2.new(0, 6, 0, 4),
				Size = UDim2.new(0, 12, 0, 12),
				BackgroundColor3 = library.flags["Menu Accent Color"],
				BorderColor3 = Color3.new(),
				Parent = option.main
			})

			tickboxOverlay = library:Create("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = option.state and 1 or 0,
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				BorderColor3 = Color3.new(),
				Image = "rbxassetid://4155801252",
				ImageTransparency = 0.6,
				ImageColor3 = Color3.new(),
				Parent = tickbox
			})

			library:Create("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = "rbxassetid://2592362371",
				ImageColor3 = Color3.fromRGB(60, 60, 60),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 62, 62),
				Parent = tickbox
			})

			library:Create("ImageLabel", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				BackgroundTransparency = 1,
				Image = "rbxassetid://2592362371",
				ImageColor3 = Color3.new(),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 62, 62),
				Parent = tickbox
			})

			table.insert(library.theme, tickbox)
		end

		option.interest = library:Create("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Parent = option.main
		})

		option.title = library:Create("TextLabel", {
			Position = UDim2.new(0, 24, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = option.text,
			TextColor3 =  option.state and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(180, 180, 180),
			TextSize = 15,
			Font = Enum.Font.Code,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = option.interest
		})

		option.interest.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				option:SetState(not option.state)
			end
			if input.UserInputType.Name == "MouseMovement" then
				if not library.warning and not library.slider then
					if option.style then
						tickbox.ImageColor3 = library.flags["Menu Accent Color"]
						--tweenService:Create(tickbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = library.flags["Menu Accent Color"]}):Play()
					else
						tickbox.BorderColor3 = library.flags["Menu Accent Color"]
						tickboxOverlay.BorderColor3 = library.flags["Menu Accent Color"]
						--tweenService:Create(tickbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.flags["Menu Accent Color"]}):Play()
						--tweenService:Create(tickboxOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.flags["Menu Accent Color"]}):Play()
					end
				end
				if option.tip then
					library.tooltip.Text = option.tip
					library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
				end
			end
		end)

		option.interest.InputChanged:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if option.tip then
					library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
				end
			end
		end)

		option.interest.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if option.style then
					tickbox.ImageColor3 = Color3.new()
					--tweenService:Create(tickbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.new()}):Play()
				else
					tickbox.BorderColor3 = Color3.new()
					tickboxOverlay.BorderColor3 = Color3.new()
					--tweenService:Create(tickbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Color3.new()}):Play()
					--tweenService:Create(tickboxOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Color3.new()}):Play()
				end
				library.tooltip.Position = UDim2.new(2)
			end
		end)

		function option:SetState(state, nocallback)
			state = typeof(state) == "boolean" and state
			state = state or false
			library.flags[self.flag] = state
			self.state = state
			option.title.TextColor3 = state and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(160, 160, 160)
			if option.style then
				tickboxOverlay.Visible = state
			else
				tickboxOverlay.BackgroundTransparency = state and 1 or 0
			end
			if not nocallback then
				self.callback(state)
			end
		end

		if option.state ~= nil then
			delay(1, function()
				if library then
					option.callback(option.state)
				end
			end)
		end

		setmetatable(option, {__newindex = function(t, i, v)
			if i == "Text" then
				option.title.Text = tostring(v)
			end
		end})
	end

	library.createButton = function(option, parent)
		option.hasInit = true

		option.main = library:Create("Frame", {
			LayoutOrder = option.position,
			Size = UDim2.new(1, 0, 0, 28),
			BackgroundTransparency = 1,
			Parent = parent
		})

		option.title = library:Create("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -5),
			Size = UDim2.new(1, -12, 0, 20),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BorderColor3 = Color3.new(),
			Text = option.text,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 15,
			Font = Enum.Font.Code,
			Parent = option.main
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.title
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.title
		})

		library:Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(253, 253, 253)),
			}),
			Rotation = -90,
			Parent = option.title
		})

		option.title.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				option.callback()
				if library then
					library.flags[option.flag] = true
				end
				if option.tip then
					library.tooltip.Text = option.tip
					library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
				end
			end
			if input.UserInputType.Name == "MouseMovement" then
				if not library.warning and not library.slider then
					option.title.BorderColor3 = library.flags["Menu Accent Color"]
				end
			end
		end)

		option.title.InputChanged:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if option.tip then
					library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
				end
			end
		end)

		option.title.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				option.title.BorderColor3 = Color3.new()
				library.tooltip.Position = UDim2.new(2)
			end
		end)
	end

	library.createBind = function(option, parent)
		option.hasInit = true

		local binding
		local holding
		local Loop

		if option.sub then
			option.main = option:getMain()
		else
			option.main = option.main or library:Create("Frame", {
				LayoutOrder = option.position,
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Parent = parent
			})

			library:Create("TextLabel", {
				Position = UDim2.new(0, 6, 0, 0),
				Size = UDim2.new(1, -12, 1, 0),
				BackgroundTransparency = 1,
				Text = option.text,
				TextSize = 15,
				Font = Enum.Font.Code,
				TextColor3 = Color3.fromRGB(210, 210, 210),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = option.main
			})
		end

		local bindinput = library:Create(option.sub and "TextButton" or "TextLabel", {
			Position = UDim2.new(1, -6 - (option.subpos or 0), 0, option.sub and 2 or 3),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.fromRGB(160, 160, 160),
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = option.main
		})

		if option.sub then
			bindinput.AutoButtonColor = false
		end

		local interest = option.sub and bindinput or option.main
		local inContact
		interest.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				binding = true
				bindinput.Text = "[...]"
				bindinput.Size = UDim2.new(0, -textService:GetTextSize(bindinput.Text, 16, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 16)
				bindinput.TextColor3 = library.flags["Menu Accent Color"]
			end
		end)

		library:AddConnection(inputService.InputBegan, function(input)
			if inputService:GetFocusedTextBox() then return end
			if binding then
				local key = (table.find(whitelistedMouseinputs, input.UserInputType) and not option.nomouse) and input.UserInputType
				option:SetKey(key or (not table.find(blacklistedKeys, input.KeyCode)) and input.KeyCode)
			else
				if (input.KeyCode.Name == option.key or input.UserInputType.Name == option.key) and not binding then
					if option.mode == "toggle" then
						library.flags[option.flag] = not library.flags[option.flag]
						option.callback(library.flags[option.flag], 0)
					else
						library.flags[option.flag] = true
						if Loop then Loop:Disconnect() option.callback(true, 0) end
						Loop = library:AddConnection(runService.RenderStepped, function(step)
							if not inputService:GetFocusedTextBox() then
								option.callback(nil, step)
							end
						end)
					end
				end
			end
		end)

		library:AddConnection(inputService.InputEnded, function(input)
			if option.key ~= "none" then
				if input.KeyCode.Name == option.key or input.UserInputType.Name == option.key then
					if Loop then
						Loop:Disconnect()
						library.flags[option.flag] = false
						option.callback(true, 0)
					end
				end
			end
		end)

		function option:SetKey(key)
			binding = false
			bindinput.TextColor3 = Color3.fromRGB(160, 160, 160)
			if Loop then Loop:Disconnect() library.flags[option.flag] = false option.callback(true, 0) end
			self.key = (key and key.Name) or key or self.key
			if self.key == "Backspace" then
				self.key = "none"
				bindinput.Text = "[NONE]"
			else
				local a = self.key
				if self.key:match"Mouse" then
					a = self.key:gsub("Button", ""):gsub("Mouse", "M")
				elseif self.key:match"Shift" or self.key:match"Alt" or self.key:match"Control" then
					a = self.key:gsub("Left", "L"):gsub("Right", "R")
				end
				bindinput.Text = "[" .. a:gsub("Control", "CTRL"):upper() .. "]"
			end
			bindinput.Size = UDim2.new(0, -textService:GetTextSize(bindinput.Text, 16, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 16)
		end
		option:SetKey()
	end

	library.createSlider = function(option, parent)
		option.hasInit = true

		if option.sub then
			option.main = option:getMain()
			option.main.Size = UDim2.new(1, 0, 0, 42)
		else
			option.main = library:Create("Frame", {
				LayoutOrder = option.position,
				Size = UDim2.new(1, 0, 0, option.textpos and 24 or 40),
				BackgroundTransparency = 1,
				Parent = parent
			})
		end

		option.slider = library:Create("Frame", {
			Position = UDim2.new(0, 6, 0, (option.sub and 22 or option.textpos and 4 or 20)),
			Size = UDim2.new(1, -12, 0, 16),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BorderColor3 = Color3.new(),
			Parent = option.main
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2454009026",
			ImageColor3 = Color3.new(),
			ImageTransparency = 0.8,
			Parent = option.slider
		})

		option.fill = library:Create("Frame", {
			BackgroundColor3 = library.flags["Menu Accent Color"],
			BorderSizePixel = 0,
			Parent = option.slider
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.slider
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.slider
		})

		option.title = library:Create("TextBox", {
			Position = UDim2.new((option.sub or option.textpos) and 0.5 or 0, (option.sub or option.textpos) and 0 or 6, 0, 0),
			Size = UDim2.new(0, 0, 0, (option.sub or option.textpos) and 14 or 18),
			BackgroundTransparency = 1,
			Text = (option.text == "nil" and "" or option.text .. ": ") .. option.value .. option.suffix,
			TextSize = (option.sub or option.textpos) and 14 or 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.fromRGB(210, 210, 210),
			TextXAlignment = Enum.TextXAlignment[(option.sub or option.textpos) and "Center" or "Left"],
			Parent = (option.sub or option.textpos) and option.slider or option.main
		})
		table.insert(library.theme, option.fill)

		library:Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(115, 115, 115)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Rotation = -90,
			Parent = option.fill
		})

		if option.min >= 0 then
			option.fill.Size = UDim2.new((option.value - option.min) / (option.max - option.min), 0, 1, 0)
		else
			option.fill.Position = UDim2.new((0 - option.min) / (option.max - option.min), 0, 0, 0)
			option.fill.Size = UDim2.new(option.value / (option.max - option.min), 0, 1, 0)
		end

		local manualInput
		option.title.Focused:connect(function()
			if not manualInput then
				option.title:ReleaseFocus()
				option.title.Text = (option.text == "nil" and "" or option.text .. ": ") .. option.value .. option.suffix
			end
		end)

		option.title.FocusLost:connect(function()
			option.slider.BorderColor3 = Color3.new()
			if manualInput then
				if tonumber(option.title.Text) then
					option:SetValue(tonumber(option.title.Text))
				else
					option.title.Text = (option.text == "nil" and "" or option.text .. ": ") .. option.value .. option.suffix
				end
			end
			manualInput = false
		end)

		local interest = (option.sub or option.textpos) and option.slider or option.main
		interest.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				if inputService:IsKeyDown(Enum.KeyCode.LeftControl) or inputService:IsKeyDown(Enum.KeyCode.RightControl) then
					manualInput = true
					option.title:CaptureFocus()
				else
					library.slider = option
					option.slider.BorderColor3 = library.flags["Menu Accent Color"]
					option:SetValue(option.min + ((input.Position.X - option.slider.AbsolutePosition.X) / option.slider.AbsoluteSize.X) * (option.max - option.min))
				end
			end
			if input.UserInputType.Name == "MouseMovement" then
				if not library.warning and not library.slider then
					option.slider.BorderColor3 = library.flags["Menu Accent Color"]
				end
				if option.tip then
					library.tooltip.Text = option.tip
					library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
				end
			end
		end)

		interest.InputChanged:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if option.tip then
					library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
				end
			end
		end)

		interest.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				library.tooltip.Position = UDim2.new(2)
				if option ~= library.slider then
					option.slider.BorderColor3 = Color3.new()
					--option.fill.BorderColor3 = Color3.new()
				end
			end
		end)

		function option:SetValue(value, nocallback)
			if typeof(value) ~= "number" then value = 0 end
			value = library.round(value, option.float)
			value = math.clamp(value, self.min, self.max)
			if self.min >= 0 then
				option.fill:TweenSize(UDim2.new((value - self.min) / (self.max - self.min), 0, 1, 0), "Out", "Quad", 0.05, true)
			else
				option.fill:TweenPosition(UDim2.new((0 - self.min) / (self.max - self.min), 0, 0, 0), "Out", "Quad", 0.05, true)
				option.fill:TweenSize(UDim2.new(value / (self.max - self.min), 0, 1, 0), "Out", "Quad", 0.1, true)
			end
			library.flags[self.flag] = value
			self.value = value
			option.title.Text = (option.text == "nil" and "" or option.text .. ": ") .. option.value .. option.suffix
			if not nocallback then
				self.callback(value)
			end
		end
		delay(1, function()
			if library then
				option:SetValue(option.value)
			end
		end)
	end

	library.createList = function(option, parent)
		option.hasInit = true

		if option.sub then
			option.main = option:getMain()
			option.main.Size = UDim2.new(1, 0, 0, 48)
		else
			option.main = library:Create("Frame", {
				LayoutOrder = option.position,
				Size = UDim2.new(1, 0, 0, option.text == "nil" and 30 or 48),
				BackgroundTransparency = 1,
				Parent = parent
			})

			if option.text ~= "nil" then
				library:Create("TextLabel", {
					Position = UDim2.new(0, 6, 0, 0),
					Size = UDim2.new(1, -12, 0, 18),
					BackgroundTransparency = 1,
					Text = option.text,
					TextSize = 15,
					Font = Enum.Font.Code,
					TextColor3 = Color3.fromRGB(210, 210, 210),
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = option.main
				})
			end
		end

		local function getMultiText()
			local s = ""
			for _, value in next, option.values do
				s = s .. (option.value[value] and (tostring(value) .. ", ") or "")
			end
			return string.sub(s, 1, #s - 2)
		end

		option.listvalue = library:Create("TextLabel", {
			Position = UDim2.new(0, 6, 0, (option.text == "nil" and not option.sub) and 4 or 22),
			Size = UDim2.new(1, -12, 0, 22),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BorderColor3 = Color3.new(),
			Text = " " .. (typeof(option.value) == "string" and option.value or getMultiText()),
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = option.main
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2454009026",
			ImageColor3 = Color3.new(),
			ImageTransparency = 0.8,
			Parent = option.listvalue
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.listvalue
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.listvalue
		})

		option.arrow = library:Create("ImageLabel", {
			Position = UDim2.new(1, -16, 0, 7),
			Size = UDim2.new(0, 8, 0, 8),
			Rotation = 90,
			BackgroundTransparency = 1,
			Image = "rbxassetid://4918373417",
			ImageColor3 = Color3.new(1, 1, 1),
			ScaleType = Enum.ScaleType.Fit,
			ImageTransparency = 0.4,
			Parent = option.listvalue
		})

		option.holder = library:Create("TextButton", {
			ZIndex = 4,
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			BorderColor3 = Color3.new(),
			Text = "",
			AutoButtonColor = false,
			Visible = false,
			Parent = library.base
		})

		option.content = library:Create("ScrollingFrame", {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = Color3.new(),
			ScrollBarThickness = 3,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			Parent = option.holder
		})

		library:Create("ImageLabel", {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.holder
		})

		library:Create("ImageLabel", {
			ZIndex = 4,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.holder
		})

		local layout = library:Create("UIListLayout", {
			Padding = UDim.new(0, 2),
			Parent = option.content
		})

		library:Create("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			Parent = option.content
		})

		local valueCount = 0
		layout.Changed:connect(function()
			option.holder.Size = UDim2.new(0, option.listvalue.AbsoluteSize.X, 0, 8 + (valueCount > option.max and (-2 + (option.max * 22)) or layout.AbsoluteContentSize.Y))
			option.content.CanvasSize = UDim2.new(0, 0, 0, 8 + layout.AbsoluteContentSize.Y)
		end)
		local interest = option.sub and option.listvalue or option.main

		option.listvalue.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				if library.popup == option then library.popup:Close() return end
				if library.popup then
					library.popup:Close()
				end
				option.arrow.Rotation = -90
				option.open = true
				option.holder.Visible = true
				local pos = option.main.AbsolutePosition
				option.holder.Position = UDim2.new(0, pos.X + 6, 0, pos.Y + ((option.text == "nil" and not option.sub) and 66 or 84))
				library.popup = option
				option.listvalue.BorderColor3 = library.flags["Menu Accent Color"]
			end
			if input.UserInputType.Name == "MouseMovement" then
				if not library.warning and not library.slider then
					option.listvalue.BorderColor3 = library.flags["Menu Accent Color"]
				end
			end
		end)

		option.listvalue.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if not option.open then
					option.listvalue.BorderColor3 = Color3.new()
				end
			end
		end)

		interest.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if option.tip then
					library.tooltip.Text = option.tip
					library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
				end
			end
		end)

		interest.InputChanged:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if option.tip then
					library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
				end
			end
		end)

		interest.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				library.tooltip.Position = UDim2.new(2)
			end
		end)

		local selected
		function option:AddValue(value, state)
			if self.labels[value] then return end
			valueCount = valueCount + 1

			if self.multiselect then
				self.values[value] = state
			else
				if not table.find(self.values, value) then
					table.insert(self.values, value)
				end
			end

			local label = library:Create("TextLabel", {
				ZIndex = 4,
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Text = value,
				TextSize = 15,
				Font = Enum.Font.Code,
				TextTransparency = self.multiselect and (self.value[value] and 1 or 0) or self.value == value and 1 or 0,
				TextColor3 = Color3.fromRGB(210, 210, 210),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = option.content
			})
			self.labels[value] = label

			local labelOverlay = library:Create("TextLabel", {
				ZIndex = 4,	
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 0.8,
				Text = " " ..value,
				TextSize = 15,
				Font = Enum.Font.Code,
				TextColor3 = library.flags["Menu Accent Color"],
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = self.multiselect and self.value[value] or self.value == value,
				Parent = label
			})
			selected = selected or self.value == value and labelOverlay
			table.insert(library.theme, labelOverlay)

			label.InputBegan:connect(function(input)
				if input.UserInputType.Name == "MouseButton1" then
					if self.multiselect then
						self.value[value] = not self.value[value]
						self:SetValue(self.value)
					else
						self:SetValue(value)
						self:Close()
					end
				end
			end)
		end

		for i, value in next, option.values do
			option:AddValue(tostring(typeof(i) == "number" and value or i))
		end

		function option:RemoveValue(value)
			local label = self.labels[value]
			if label then
				label:Destroy()
				self.labels[value] = nil
				valueCount = valueCount - 1
				if self.multiselect then
					self.values[value] = nil
					self:SetValue(self.value)
				else
					table.remove(self.values, table.find(self.values, value))
					if self.value == value then
						selected = nil
						self:SetValue(self.values[1] or "")
					end
				end
			end
		end

		function option:SetValue(value, nocallback)
			if self.multiselect and typeof(value) ~= "table" then
				value = {}
				for i,v in next, self.values do
					value[v] = false
				end
			end
			self.value = typeof(value) == "table" and value or tostring(table.find(self.values, value) and value or self.values[1])
			library.flags[self.flag] = self.value
			option.listvalue.Text = " " .. (self.multiselect and getMultiText() or self.value)
			if self.multiselect then
				for name, label in next, self.labels do
					label.TextTransparency = self.value[name] and 1 or 0
					if label:FindFirstChild"TextLabel" then
						label.TextLabel.Visible = self.value[name]
					end
				end
			else
				if selected then
					selected.TextTransparency = 0
					if selected:FindFirstChild"TextLabel" then
						selected.TextLabel.Visible = false
					end
				end
				if self.labels[self.value] then
					selected = self.labels[self.value]
					selected.TextTransparency = 1
					if selected:FindFirstChild"TextLabel" then
						selected.TextLabel.Visible = true
					end
				end
			end
			if not nocallback then
				self.callback(self.value)
			end
		end
		delay(1, function()
			if library then
				option:SetValue(option.value)
			end
		end)

		function option:Close()
			library.popup = nil
			option.arrow.Rotation = 90
			self.open = false
			option.holder.Visible = false
			option.listvalue.BorderColor3 = Color3.new()
		end

		return option
	end

	library.createBox = function(option, parent)
		option.hasInit = true

		option.main = library:Create("Frame", {
			LayoutOrder = option.position,
			Size = UDim2.new(1, 0, 0, option.text == "nil" and 28 or 44),
			BackgroundTransparency = 1,
			Parent = parent
		})

		if option.text ~= "nil" then
			option.title = library:Create("TextLabel", {
				Position = UDim2.new(0, 6, 0, 0),
				Size = UDim2.new(1, -12, 0, 18),
				BackgroundTransparency = 1,
				Text = option.text,
				TextSize = 15,
				Font = Enum.Font.Code,
				TextColor3 = Color3.fromRGB(210, 210, 210),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = option.main
			})
		end

		option.holder = library:Create("Frame", {
			Position = UDim2.new(0, 6, 0, option.text == "nil" and 4 or 20),
			Size = UDim2.new(1, -12, 0, 20),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BorderColor3 = Color3.new(),
			Parent = option.main
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2454009026",
			ImageColor3 = Color3.new(),
			ImageTransparency = 0.8,
			Parent = option.holder
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.holder
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.holder
		})

		local inputvalue = library:Create("TextBox", {
			Position = UDim2.new(0, 4, 0, 0),
			Size = UDim2.new(1, -4, 1, 0),
			BackgroundTransparency = 1,
			Text = "  " .. option.value,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			ClearTextOnFocus = false,
			Parent = option.holder
		})

		inputvalue.FocusLost:connect(function(enter)
			option.holder.BorderColor3 = Color3.new()
			option:SetValue(inputvalue.Text, enter)
		end)

		inputvalue.Focused:connect(function()
			option.holder.BorderColor3 = library.flags["Menu Accent Color"]
		end)

		inputvalue.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				inputvalue.Text = ""
			end
			if input.UserInputType.Name == "MouseMovement" then
				if not library.warning and not library.slider then
					option.holder.BorderColor3 = library.flags["Menu Accent Color"]
				end
				if option.tip then
					library.tooltip.Text = option.tip
					library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
				end
			end
		end)

		inputvalue.InputChanged:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if option.tip then
					library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
				end
			end
		end)

		inputvalue.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if not inputvalue:IsFocused() then
					option.holder.BorderColor3 = Color3.new()
				end
				library.tooltip.Position = UDim2.new(2)
			end
		end)

		function option:SetValue(value, enter)
			if tostring(value) == "" then
				inputvalue.Text = self.value
			else
				library.flags[self.flag] = tostring(value)
				self.value = tostring(value)
				inputvalue.Text = self.value
				self.callback(value, enter)
			end
		end
		delay(1, function()
			if library then
				option:SetValue(option.value)
			end
		end)
	end

	library.createColorPickerWindow = function(option)
		option.mainHolder = library:Create("TextButton", {
			ZIndex = 4,
			--Position = UDim2.new(1, -184, 1, 6),
			Size = UDim2.new(0, option.trans and 200 or 184, 0, 264),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			BorderColor3 = Color3.new(),
			AutoButtonColor = false,
			Visible = false,
			Parent = library.base
		})

		option.rgbBox = library:Create("Frame", {
			Position = UDim2.new(0, 6, 0, 214),
			Size = UDim2.new(0, (option.mainHolder.AbsoluteSize.X - 12), 0, 20),
			BackgroundColor3 = Color3.fromRGB(57, 57, 57),
			BorderColor3 = Color3.new(),
			ZIndex = 5;
			Parent = option.mainHolder
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2454009026",
			ImageColor3 = Color3.new(),
			ImageTransparency = 0.8,
			ZIndex = 6;
			Parent = option.rgbBox
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			ZIndex = 6;
			Parent = option.rgbBox
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			ZIndex = 6;
			Parent = option.rgbBox
		})

		option.rgbInput = library:Create("TextBox", {
			Position = UDim2.new(0, 4, 0, 0),
			Size = UDim2.new(1, -4, 1, 0),
			BackgroundTransparency = 1,
			Text = tostring(option.color),
			TextSize = 14,
			Font = Enum.Font.Code,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = true,
			ClearTextOnFocus = false,
			ZIndex = 6;
			Parent = option.rgbBox
		})

		option.hexBox = option.rgbBox:Clone()
		option.hexBox.Position = UDim2.new(0, 6, 0, 238)
		-- option.hexBox.Size = UDim2.new(0, (option.mainHolder.AbsoluteSize.X/2 - 10), 0, 20)
		option.hexBox.Parent = option.mainHolder
		option.hexInput = option.hexBox.TextBox;

		library:Create("ImageLabel", {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.mainHolder
		})

		library:Create("ImageLabel", {
			ZIndex = 4,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.mainHolder
		})

		local hue, sat, val = Color3.toHSV(option.color)
		hue, sat, val = hue == 0 and 1 or hue, sat + 0.005, val - 0.005
		local editinghue
		local editingsatval
		local editingtrans

		local transMain
		if option.trans then
			transMain = library:Create("ImageLabel", {
				ZIndex = 5,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = "rbxassetid://2454009026",
				ImageColor3 = Color3.fromHSV(hue, 1, 1),
				Rotation = 180,
				Parent = library:Create("ImageLabel", {
					ZIndex = 4,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -6, 0, 6),
					Size = UDim2.new(0, 10, 1, -60),
					BorderColor3 = Color3.new(),
					Image = "rbxassetid://4632082392",
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.new(0, 5, 0, 5),
					Parent = option.mainHolder
				})
			})

			option.transSlider = library:Create("Frame", {
				ZIndex = 5,
				Position = UDim2.new(0, 0, option.trans, 0),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = Color3.fromRGB(38, 41, 65),
				BorderColor3 = Color3.fromRGB(255, 255, 255),
				Parent = transMain
			})

			transMain.InputBegan:connect(function(Input)
				if Input.UserInputType.Name == "MouseButton1" then
					editingtrans = true
					option:SetTrans(1 - ((Input.Position.Y - transMain.AbsolutePosition.Y) / transMain.AbsoluteSize.Y))
				end
			end)

			transMain.InputEnded:connect(function(Input)
				if Input.UserInputType.Name == "MouseButton1" then
					editingtrans = false
				end
			end)
		end

		local hueMain = library:Create("Frame", {
			ZIndex = 4,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 6, 1, -54),
			Size = UDim2.new(1, option.trans and -28 or -12, 0, 10),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(),
			Parent = option.mainHolder
		})

		local Gradient = library:Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
				ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
			}),
			Parent = hueMain
		})

		local hueSlider = library:Create("Frame", {
			ZIndex = 4,
			Position = UDim2.new(1 - hue, 0, 0, 0),
			Size = UDim2.new(0, 2, 1, 0),
			BackgroundColor3 = Color3.fromRGB(38, 41, 65),
			BorderColor3 = Color3.fromRGB(255, 255, 255),
			Parent = hueMain
		})

		hueMain.InputBegan:connect(function(Input)
			if Input.UserInputType.Name == "MouseButton1" then
				editinghue = true
				X = (hueMain.AbsolutePosition.X + hueMain.AbsoluteSize.X) - hueMain.AbsolutePosition.X
				X = math.clamp((Input.Position.X - hueMain.AbsolutePosition.X) / X, 0, 0.995)
				option:SetColor(Color3.fromHSV(1 - X, sat, val))
			end
		end)

		hueMain.InputEnded:connect(function(Input)
			if Input.UserInputType.Name == "MouseButton1" then
				editinghue = false
			end
		end)

		local satval = library:Create("ImageLabel", {
			ZIndex = 4,
			Position = UDim2.new(0, 6, 0, 6),
			Size = UDim2.new(1, option.trans and -28 or -12, 1, -74),
			BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
			BorderColor3 = Color3.new(),
			Image = "rbxassetid://4155801252",
			ClipsDescendants = true,
			Parent = option.mainHolder
		})

		local satvalSlider = library:Create("Frame", {
			ZIndex = 4,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(sat, 0, 1 - val, 0),
			Size = UDim2.new(0, 4, 0, 4),
			Rotation = 45,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Parent = satval
		})

		satval.InputBegan:connect(function(Input)
			if Input.UserInputType.Name == "MouseButton1" then
				editingsatval = true
				X = (satval.AbsolutePosition.X + satval.AbsoluteSize.X) - satval.AbsolutePosition.X
				Y = (satval.AbsolutePosition.Y + satval.AbsoluteSize.Y) - satval.AbsolutePosition.Y
				X = math.clamp((Input.Position.X - satval.AbsolutePosition.X) / X, 0.005, 1)
				Y = math.clamp((Input.Position.Y - satval.AbsolutePosition.Y) / Y, 0, 0.995)
				option:SetColor(Color3.fromHSV(hue, X, 1 - Y))
			end
		end)

		library:AddConnection(inputService.InputChanged, function(Input)
			if Input.UserInputType.Name == "MouseMovement" then
				if editingsatval then
					X = (satval.AbsolutePosition.X + satval.AbsoluteSize.X) - satval.AbsolutePosition.X
					Y = (satval.AbsolutePosition.Y + satval.AbsoluteSize.Y) - satval.AbsolutePosition.Y
					X = math.clamp((Input.Position.X - satval.AbsolutePosition.X) / X, 0.005, 1)
					Y = math.clamp((Input.Position.Y - satval.AbsolutePosition.Y) / Y, 0, 0.995)
					option:SetColor(Color3.fromHSV(hue, X, 1 - Y))
				elseif editinghue then
					X = (hueMain.AbsolutePosition.X + hueMain.AbsoluteSize.X) - hueMain.AbsolutePosition.X
					X = math.clamp((Input.Position.X - hueMain.AbsolutePosition.X) / X, 0, 0.995)
					option:SetColor(Color3.fromHSV(1 - X, sat, val))
				elseif editingtrans then
					option:SetTrans(1 - ((Input.Position.Y - transMain.AbsolutePosition.Y) / transMain.AbsoluteSize.Y))
				end
			end
		end)

		satval.InputEnded:connect(function(Input)
			if Input.UserInputType.Name == "MouseButton1" then
				editingsatval = false
			end
		end)

		local r, g, b = library.round(option.color)
		option.hexInput.Text = string.format("#%02x%02x%02x", r, g, b)
		option.rgbInput.Text = table.concat({r, g, b}, ",")

		option.rgbInput.FocusLost:connect(function()
			local r, g, b = option.rgbInput.Text:gsub("%s+", ""):match("(%d+),(%d+),(%d+)")
			if r and g and b then
				local color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
				return option:SetColor(color)
			end

			local r, g, b = library.round(option.color)
			option.rgbInput.Text = table.concat({r, g, b}, ",")
		end)

		option.hexInput.FocusLost:connect(function()
			local r, g, b = option.hexInput.Text:match("#?(..)(..)(..)")
			if r and g and b then
				local color = Color3.fromRGB(tonumber("0x"..r), tonumber("0x"..g), tonumber("0x"..b))
				return option:SetColor(color)
			end

			local r, g, b = library.round(option.color)
			option.hexInput.Text = string.format("#%02x%02x%02x", r, g, b)
		end)

		function option:updateVisuals(Color)
			hue, sat, val = Color3.toHSV(Color)
			hue = hue == 0 and 1 or hue
			satval.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
			if option.trans then
				transMain.ImageColor3 = Color3.fromHSV(hue, 1, 1)
			end
			hueSlider.Position = UDim2.new(1 - hue, 0, 0, 0)
			satvalSlider.Position = UDim2.new(sat, 0, 1 - val, 0)

			local r, g, b = library.round(Color3.fromHSV(hue, sat, val))

			option.hexInput.Text = string.format("#%02x%02x%02x", r, g, b)
			option.rgbInput.Text = table.concat({r, g, b}, ",")
		end

		return option
	end

	library.createColor = function(option, parent)
		option.hasInit = true

		if option.sub then
			option.main = option:getMain()
		else
			option.main = library:Create("Frame", {
				LayoutOrder = option.position,
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Parent = parent
			})

			option.title = library:Create("TextLabel", {
				Position = UDim2.new(0, 6, 0, 0),
				Size = UDim2.new(1, -12, 1, 0),
				BackgroundTransparency = 1,
				Text = option.text,
				TextSize = 15,
				Font = Enum.Font.Code,
				TextColor3 = Color3.fromRGB(210, 210, 210),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = option.main
			})
		end

		option.visualize = library:Create(option.sub and "TextButton" or "Frame", {
			Position = UDim2.new(1, -(option.subpos or 0) - 24, 0, 4),
			Size = UDim2.new(0, 18, 0, 12),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundColor3 = option.color,
			BorderColor3 = Color3.new(),
			Parent = option.main
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2454009026",
			ImageColor3 = Color3.new(),
			ImageTransparency = 0.6,
			Parent = option.visualize
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.visualize
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = option.visualize
		})

		local interest = option.sub and option.visualize or option.main

		if option.sub then
			option.visualize.Text = ""
			option.visualize.AutoButtonColor = false
		end

		interest.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				if not option.mainHolder then library.createColorPickerWindow(option) end
				if library.popup == option then library.popup:Close() return end
				if library.popup then library.popup:Close() end
				option.open = true
				local pos = option.main.AbsolutePosition
				option.mainHolder.Position = UDim2.new(0, pos.X + 36 + (option.trans and -16 or 0), 0, pos.Y + 56)
				option.mainHolder.Visible = true
				library.popup = option
				option.visualize.BorderColor3 = library.flags["Menu Accent Color"]
			end
			if input.UserInputType.Name == "MouseMovement" then
				if not library.warning and not library.slider then
					option.visualize.BorderColor3 = library.flags["Menu Accent Color"]
				end
				if option.tip then
					library.tooltip.Text = option.tip
					library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
				end
			end
		end)

		interest.InputChanged:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if option.tip then
					library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
				end
			end
		end)

		interest.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseMovement" then
				if not option.open then
					option.visualize.BorderColor3 = Color3.new()
				end
				library.tooltip.Position = UDim2.new(2)
			end
		end)

		function option:SetColor(newColor, nocallback)
			if typeof(newColor) == "table" then
				newColor = Color3.new(newColor[1], newColor[2], newColor[3])
			end
			newColor = newColor or Color3.new(1, 1, 1)
			if self.mainHolder then
				self:updateVisuals(newColor)
			end
			option.visualize.BackgroundColor3 = newColor
			library.flags[self.flag] = newColor
			self.color = newColor
			if not nocallback then
				self.callback(newColor)
			end
		end

		if option.trans then
			function option:SetTrans(value, manual)
				value = math.clamp(tonumber(value) or 0, 0, 1)
				if self.transSlider then
					self.transSlider.Position = UDim2.new(0, 0, value, 0)
				end
				self.trans = value
				library.flags[self.flag .. " Transparency"] = 1 - value
				self.calltrans(value)
			end
			option:SetTrans(option.trans)
		end

		delay(1, function()
			if library then
				option:SetColor(option.color)
			end
		end)

		function option:Close()
			library.popup = nil
			self.open = false
			self.mainHolder.Visible = false
			option.visualize.BorderColor3 = Color3.new()
		end
	end

	function library:AddTab(title, pos)
		local tab = {canInit = true, tabs = {}, columns = {}, title = tostring(title)}
		table.insert(self.tabs, pos or #self.tabs + 1, tab)

		function tab:AddColumn()
			local column = {sections = {}, position = #self.columns, canInit = true, tab = self}
			table.insert(self.columns, column)

			function column:AddSection(title)
				local section = {title = tostring(title), options = {}, canInit = true, column = self}
				table.insert(self.sections, section)

				function section:AddLabel(text)
					local option = {text = text}
					option.section = self
					option.type = "label"
					option.position = #self.options
					option.canInit = true
					table.insert(self.options, option)

					if library.hasInit and self.hasInit then
						library.createLabel(option, self.content)
					else
						option.Init = library.createLabel
					end

					return option
				end

				function section:AddDivider(text)
					local option = {text = text}
					option.section = self
					option.type = "divider"
					option.position = #self.options
					option.canInit = true
					table.insert(self.options, option)

					if library.hasInit and self.hasInit then
						library.createDivider(option, self.content)
					else
						option.Init = library.createDivider
					end

					return option
				end

				function section:AddToggle(option)
					option = typeof(option) == "table" and option or {}
					option.section = self
					option.text = tostring(option.text)
					option.state = option.state == nil and nil or (typeof(option.state) == "boolean" and option.state or false)
					option.callback = typeof(option.callback) == "function" and option.callback or function() end
					option.type = "toggle"
					option.position = #self.options
					option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
					option.subcount = 0
					option.canInit = (option.canInit ~= nil and option.canInit) or true
					option.tip = option.tip and tostring(option.tip)
					option.style = option.style == 2
					library.flags[option.flag] = option.state
					table.insert(self.options, option)
					library.options[option.flag] = option

					function option:AddColor(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddColor(subOption)
					end

					function option:AddBind(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddBind(subOption)
					end

					function option:AddList(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddList(subOption)
					end

					function option:AddSlider(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddSlider(subOption)
					end

					if library.hasInit and self.hasInit then
						library.createToggle(option, self.content)
					else
						option.Init = library.createToggle
					end

					return option
				end

				function section:AddButton(option)
					option = typeof(option) == "table" and option or {}
					option.section = self
					option.text = tostring(option.text)
					option.callback = typeof(option.callback) == "function" and option.callback or function() end
					option.type = "button"
					option.position = #self.options
					option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
					option.subcount = 0
					option.canInit = (option.canInit ~= nil and option.canInit) or true
					option.tip = option.tip and tostring(option.tip)
					table.insert(self.options, option)
					library.options[option.flag] = option

					function option:AddBind(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() option.main.Size = UDim2.new(1, 0, 0, 40) return option.main end
						self.subcount = self.subcount + 1
						return section:AddBind(subOption)
					end

					function option:AddColor(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() option.main.Size = UDim2.new(1, 0, 0, 40) return option.main end
						self.subcount = self.subcount + 1
						return section:AddColor(subOption)
					end

					if library.hasInit and self.hasInit then
						library.createButton(option, self.content)
					else
						option.Init = library.createButton
					end

					return option
				end

				function section:AddBind(option)
					option = typeof(option) == "table" and option or {}
					option.section = self
					option.text = tostring(option.text)
					option.key = (option.key and option.key.Name) or option.key or "none"
					option.nomouse = typeof(option.nomouse) == "boolean" and option.nomouse or false
					option.mode = typeof(option.mode) == "string" and (option.mode == "toggle" or option.mode == "hold" and option.mode) or "toggle"
					option.callback = typeof(option.callback) == "function" and option.callback or function() end
					option.type = "bind"
					option.position = #self.options
					option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
					option.canInit = (option.canInit ~= nil and option.canInit) or true
					option.tip = option.tip and tostring(option.tip)
					table.insert(self.options, option)
					library.options[option.flag] = option

					if library.hasInit and self.hasInit then
						library.createBind(option, self.content)
					else
						option.Init = library.createBind
					end

					return option
				end

				function section:AddSlider(option)
					option = typeof(option) == "table" and option or {}
					option.section = self
					option.text = tostring(option.text)
					option.min = typeof(option.min) == "number" and option.min or 0
					option.max = typeof(option.max) == "number" and option.max or 0
					option.value = option.min < 0 and 0 or math.clamp(typeof(option.value) == "number" and option.value or option.min, option.min, option.max)
					option.callback = typeof(option.callback) == "function" and option.callback or function() end
					option.float = typeof(option.value) == "number" and option.float or 1
					option.suffix = option.suffix and tostring(option.suffix) or ""
					option.textpos = option.textpos == 2
					option.type = "slider"
					option.position = #self.options
					option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
					option.subcount = 0
					option.canInit = (option.canInit ~= nil and option.canInit) or true
					option.tip = option.tip and tostring(option.tip)
					library.flags[option.flag] = option.value
					table.insert(self.options, option)
					library.options[option.flag] = option

					function option:AddColor(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddColor(subOption)
					end

					function option:AddBind(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddBind(subOption)
					end

					if library.hasInit and self.hasInit then
						library.createSlider(option, self.content)
					else
						option.Init = library.createSlider
					end

					return option
				end

				function section:AddList(option)
					option = typeof(option) == "table" and option or {}
					option.section = self
					option.text = tostring(option.text)
					option.values = typeof(option.values) == "table" and option.values or {}
					option.callback = typeof(option.callback) == "function" and option.callback or function() end
					option.multiselect = typeof(option.multiselect) == "boolean" and option.multiselect or false
					--option.groupbox = (not option.multiselect) and (typeof(option.groupbox) == "boolean" and option.groupbox or false)
					option.value = option.multiselect and (typeof(option.value) == "table" and option.value or {}) or tostring(option.value or option.values[1] or "")
					if option.multiselect then
						for i,v in next, option.values do
							option.value[v] = false
						end
					end
					option.max = option.max or 4
					option.open = false
					option.type = "list"
					option.position = #self.options
					option.labels = {}
					option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
					option.subcount = 0
					option.canInit = (option.canInit ~= nil and option.canInit) or true
					option.tip = option.tip and tostring(option.tip)
					library.flags[option.flag] = option.value
					table.insert(self.options, option)
					library.options[option.flag] = option

					function option:AddValue(value, state)
						if self.multiselect then
							self.values[value] = state
						else
							table.insert(self.values, value)
						end
					end

					function option:AddColor(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddColor(subOption)
					end

					function option:AddBind(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddBind(subOption)
					end

					if library.hasInit and self.hasInit then
						library.createList(option, self.content)
					else
						option.Init = library.createList
					end

					return option
				end

				function section:AddBox(option)
					option = typeof(option) == "table" and option or {}
					option.section = self
					option.text = tostring(option.text)
					option.value = tostring(option.value or "")
					option.callback = typeof(option.callback) == "function" and option.callback or function() end
					option.type = "box"
					option.position = #self.options
					option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
					option.canInit = (option.canInit ~= nil and option.canInit) or true
					option.tip = option.tip and tostring(option.tip)
					library.flags[option.flag] = option.value
					table.insert(self.options, option)
					library.options[option.flag] = option

					if library.hasInit and self.hasInit then
						library.createBox(option, self.content)
					else
						option.Init = library.createBox
					end

					return option
				end

				function section:AddColor(option)
					option = typeof(option) == "table" and option or {}
					option.section = self
					option.text = tostring(option.text)
					option.color = typeof(option.color) == "table" and Color3.new(option.color[1], option.color[2], option.color[3]) or option.color or Color3.new(1, 1, 1)
					option.callback = typeof(option.callback) == "function" and option.callback or function() end
					option.calltrans = typeof(option.calltrans) == "function" and option.calltrans or (option.calltrans == 1 and option.callback) or function() end
					option.open = false
					option.trans = tonumber(option.trans)
					option.subcount = 1
					option.type = "color"
					option.position = #self.options
					option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
					option.canInit = (option.canInit ~= nil and option.canInit) or true
					option.tip = option.tip and tostring(option.tip)
					library.flags[option.flag] = option.color
					table.insert(self.options, option)
					library.options[option.flag] = option

					function option:AddColor(subOption)
						subOption = typeof(subOption) == "table" and subOption or {}
						subOption.sub = true
						subOption.subpos = self.subcount * 24
						function subOption:getMain() return option.main end
						self.subcount = self.subcount + 1
						return section:AddColor(subOption)
					end

					if option.trans then
						library.flags[option.flag .. " Transparency"] = option.trans
					end

					if library.hasInit and self.hasInit then
						library.createColor(option, self.content)
					else
						option.Init = library.createColor
					end

					return option
				end

				function section:SetTitle(newTitle)
					self.title = tostring(newTitle)
					if self.titleText then
						self.titleText.Text = tostring(newTitle)
					end
				end

				function section:Init()
					if self.hasInit then return end
					self.hasInit = true

					self.main = library:Create("Frame", {
						BackgroundColor3 = Color3.fromRGB(30, 30, 30),
						BorderColor3 = Color3.new(),
						Parent = column.main
					})

					self.content = library:Create("Frame", {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundColor3 = Color3.fromRGB(30, 30, 30),
						BorderColor3 = Color3.fromRGB(60, 60, 60),
						BorderMode = Enum.BorderMode.Inset,
						Parent = self.main
					})

					library:Create("ImageLabel", {
						Size = UDim2.new(1, -2, 1, -2),
						Position = UDim2.new(0, 1, 0, 1),
						BackgroundTransparency = 1,
						Image = "rbxassetid://2592362371",
						ImageColor3 = Color3.new(),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 62, 62),
						Parent = self.main
					})

					table.insert(library.theme, library:Create("Frame", {
						Size = UDim2.new(1, 0, 0, 1),
						BackgroundColor3 = library.flags["Menu Accent Color"],
						BorderSizePixel = 0,
						BorderMode = Enum.BorderMode.Inset,
						Parent = self.main
					}))

					local layout = library:Create("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 2),
						Parent = self.content
					})

					library:Create("UIPadding", {
						PaddingTop = UDim.new(0, 12),
						Parent = self.content
					})

					self.titleText = library:Create("TextLabel", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 12, 0, 0),
						Size = UDim2.new(0, textService:GetTextSize(self.title, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 10, 0, 3),
						BackgroundColor3 = Color3.fromRGB(30, 30, 30),
						BorderSizePixel = 0,
						Text = self.title,
						TextSize = 15,
						Font = Enum.Font.Code,
						TextColor3 = Color3.new(1, 1, 1),
						Parent = self.main
					})

					layout.Changed:connect(function()
						self.main.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 16)
					end)

					for _, option in next, self.options do
						if option.canInit then
							option.Init(option, self.content)
						end
					end
				end

				if library.hasInit and self.hasInit then
					section:Init()
				end

				return section
			end

			function column:Init()
				if self.hasInit then return end
				self.hasInit = true

				self.main = library:Create("ScrollingFrame", {
					ZIndex = 2,
					Position = UDim2.new(0, 6 + (self.position * 239), 0, 2),
					Size = UDim2.new(0, 233, 1, -4),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarImageColor3 = Color3.fromRGB(),
					ScrollBarThickness = 4,	
					VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Visible = false,
					Parent = library.columnHolder
				})

				local layout = library:Create("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12),
					Parent = self.main
				})

				library:Create("UIPadding", {
					PaddingTop = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 2),
					PaddingRight = UDim.new(0, 2),
					Parent = self.main
				})

				layout.Changed:connect(function()
					self.main.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 14)
				end)

				for _, section in next, self.sections do
					if section.canInit and #section.options > 0 then
						section:Init()
					end
				end
			end

			if library.hasInit and self.hasInit then
				column:Init()
			end

			return column
		end

		function tab:Init()
			if self.hasInit then return end
			self.hasInit = true
			local size = textService:GetTextSize(self.title, 18, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 10

			self.button = library:Create("TextLabel", {
				Position = UDim2.new(0, library.tabSize, 0, 22),
				Size = UDim2.new(0, size, 0, 30),
				BackgroundTransparency = 1,
				Text = self.title,
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 15,
				Font = Enum.Font.Code,
				TextWrapped = true,
				ClipsDescendants = true,
				Parent = library.main
			})
			library.tabSize = library.tabSize + size

			self.button.InputBegan:connect(function(input)
				if input.UserInputType.Name == "MouseButton1" then
					library:selectTab(self)
				end
			end)

			for _, column in next, self.columns do
				if column.canInit then
					column:Init()
				end
			end
		end

		if self.hasInit then
			tab:Init()
		end

		return tab
	end

	function library:AddWarning(warning)
		warning = typeof(warning) == "table" and warning or {}
		warning.text = tostring(warning.text) 
		warning.type = warning.type == "confirm" and "confirm" or ""

		local answer
		function warning:Show()
			library.warning = warning
			if warning.main and warning.type == "" then return end
			if library.popup then library.popup:Close() end
			if not warning.main then
				warning.main = library:Create("TextButton", {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 0.6,
					BackgroundColor3 = Color3.new(),
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Parent = library.main
				})

				warning.message = library:Create("TextLabel", {
					ZIndex = 2,
					Position = UDim2.new(0, 20, 0.5, -60),
					Size = UDim2.new(1, -40, 0, 40),
					BackgroundTransparency = 1,
					TextSize = 16,
					Font = Enum.Font.Code,
					TextColor3 = Color3.new(1, 1, 1),
					TextWrapped = true,
					RichText = true,
					Parent = warning.main
				})

				if warning.type == "confirm" then
					local button = library:Create("TextLabel", {
						ZIndex = 2,
						Position = UDim2.new(0.5, -105, 0.5, -10),
						Size = UDim2.new(0, 100, 0, 20),
						BackgroundColor3 = Color3.fromRGB(40, 40, 40),
						BorderColor3 = Color3.new(),
						Text = "Yes",
						TextSize = 16,
						Font = Enum.Font.Code,
						TextColor3 = Color3.new(1, 1, 1),
						Parent = warning.main
					})

					library:Create("ImageLabel", {
						ZIndex = 2,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = "rbxassetid://2454009026",
						ImageColor3 = Color3.new(),
						ImageTransparency = 0.8,
						Parent = button
					})

					library:Create("ImageLabel", {
						ZIndex = 2,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = "rbxassetid://2592362371",
						ImageColor3 = Color3.fromRGB(60, 60, 60),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 62, 62),
						Parent = button
					})

					local button1 = library:Create("TextLabel", {
						ZIndex = 2,
						Position = UDim2.new(0.5, 5, 0.5, -10),
						Size = UDim2.new(0, 100, 0, 20),
						BackgroundColor3 = Color3.fromRGB(40, 40, 40),
						BorderColor3 = Color3.new(),
						Text = "No",
						TextSize = 16,
						Font = Enum.Font.Code,
						TextColor3 = Color3.new(1, 1, 1),
						Parent = warning.main
					})

					library:Create("ImageLabel", {
						ZIndex = 2,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = "rbxassetid://2454009026",
						ImageColor3 = Color3.new(),
						ImageTransparency = 0.8,
						Parent = button1
					})

					library:Create("ImageLabel", {
						ZIndex = 2,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = "rbxassetid://2592362371",
						ImageColor3 = Color3.fromRGB(60, 60, 60),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 62, 62),
						Parent = button1
					})

					button.InputBegan:connect(function(input)
						if input.UserInputType.Name == "MouseButton1" then
							answer = true
						end
					end)

					button1.InputBegan:connect(function(input)
						if input.UserInputType.Name == "MouseButton1" then
							answer = false
						end
					end)
				else
					local button = library:Create("TextLabel", {
						ZIndex = 2,
						Position = UDim2.new(0.5, -50, 0.5, -10),
						Size = UDim2.new(0, 100, 0, 20),
						BackgroundColor3 = Color3.fromRGB(30, 30, 30),
						BorderColor3 = Color3.new(),
						Text = "OK",
						TextSize = 16,
						Font = Enum.Font.Code,
						TextColor3 = Color3.new(1, 1, 1),
						Parent = warning.main
					})

					library:Create("ImageLabel", {
						ZIndex = 2,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = "rbxassetid://2454009026",
						ImageColor3 = Color3.new(),
						ImageTransparency = 0.8,
						Parent = button
					})

					library:Create("ImageLabel", {
						ZIndex = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, -2, 1, -2),
						BackgroundTransparency = 1,
						Image = "rbxassetid://3570695787",
						ImageColor3 = Color3.fromRGB(50, 50, 50),
						Parent = button
					})

					button.InputBegan:connect(function(input)
						if input.UserInputType.Name == "MouseButton1" then
							answer = true
						end
					end)
				end
			end
			warning.main.Visible = true
			warning.message.Text = warning.text

			repeat wait()
			until answer ~= nil
			spawn(warning.Close)
			library.warning = nil
			return answer
		end

		function warning:Close()
			answer = nil
			if not warning.main then return end
			warning.main.Visible = false
		end

		return warning
	end

	function library:Close()
		self.open = not self.open
		if self.open then
			inputService.MouseIconEnabled = false
		else
			inputService.MouseIconEnabled = self.mousestate
		end
		if self.main then
			if self.popup then
				self.popup:Close()
			end
			self.main.Visible = self.open
			self.cursor.Visible  = self.open
			self.cursor1.Visible  = self.open
		end
	end

	function library:Init()
		if self.hasInit then return end
		self.hasInit = true

		self.base = library:Create("ScreenGui", {IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global})
		if runService:IsStudio() then
			self.base.Parent = script.Parent.Parent
		elseif syn then
			pcall(function() syn.protect_gui(self.base) end)
			self.base.Parent = game:GetService"CoreGui"
		end

		self.main = self:Create("ImageButton", {
			AutoButtonColor = false,
			Position = UDim2.new(0, 100, 0, 46),
			Size = UDim2.new(0, 500, 0, 600),
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			BorderColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Tile,
			Modal = true,
			Visible = false,
			Parent = self.base
		})

		self.top = self:Create("Frame", {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderColor3 = Color3.new(),
			Parent = self.main
		})

		self:Create("TextLabel", {
			Position = UDim2.new(0, 6, 0, -1),
			Size = UDim2.new(0, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = tostring(self.title),
			Font = Enum.Font.Code,
			TextSize = 18,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = self.main
		})

		table.insert(library.theme, self:Create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 24),
			BackgroundColor3 = library.flags["Menu Accent Color"],
			BorderSizePixel = 0,
			Parent = self.main
		}))

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2454009026",
			ImageColor3 = Color3.new(),
			ImageTransparency = 0.4,
			Parent = top
		})

		self.tabHighlight = self:Create("Frame", {
			BackgroundColor3 = library.flags["Menu Accent Color"],
			BorderSizePixel = 0,
			Parent = self.main
		})
		table.insert(library.theme, self.tabHighlight)

		self.columnHolder = self:Create("Frame", {
			Position = UDim2.new(0, 5, 0, 55),
			Size = UDim2.new(1, -10, 1, -60),
			BackgroundTransparency = 1,
			Parent = self.main
		})

		self.cursor = self:Create("Triangle", {
			Color = Color3.fromRGB(180, 180, 180),
			Transparency = 0.6,
		})
		self.cursor1 = self:Create("Triangle", {
			Color = Color3.fromRGB(240, 240, 240),
			Transparency = 0.6,
		})

		self.tooltip = self:Create("TextLabel", {
			ZIndex = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.new(1, 1, 1),
			Visible = true,
			Parent = self.base
		})

		self:Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(1, 10, 1, 0),
			Style = Enum.FrameStyle.RobloxRound,
			Parent = self.tooltip
		})

		self:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = self.main
		})

		self:Create("ImageLabel", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.new(),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = self.main
		})

		self.top.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				dragObject = self.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
				if library.popup then library.popup:Close() end
			end
		end)
		self.top.InputChanged:connect(function(input)
			if dragging and input.UserInputType.Name == "MouseMovement" then
				dragInput = input
			end
		end)
		self.top.InputEnded:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				dragging = false
			end
		end)

		function self:selectTab(tab)
			if self.currentTab == tab then return end
			if library.popup then library.popup:Close() end
			if self.currentTab then
				self.currentTab.button.TextColor3 = Color3.fromRGB(255, 255, 255)
				for _, column in next, self.currentTab.columns do
					column.main.Visible = false
				end
			end
			self.main.Size = UDim2.new(0, 16 + ((#tab.columns < 2 and 2 or #tab.columns) * 239), 0, 600)
			self.currentTab = tab
			tab.button.TextColor3 = library.flags["Menu Accent Color"]
			self.tabHighlight:TweenPosition(UDim2.new(0, tab.button.Position.X.Offset, 0, 50), "Out", "Quad", 0.2, true)
			self.tabHighlight:TweenSize(UDim2.new(0, tab.button.AbsoluteSize.X, 0, -1), "Out", "Quad", 0.1, true)
			for _, column in next, tab.columns do
				column.main.Visible = true
			end
		end

		spawn(function()
			while library do
				wait(1)
				local Configs = self:GetConfigs()
				for _, config in next, Configs do
					if not table.find(self.options["Config List"].values, config) then
						self.options["Config List"]:AddValue(config)
					end
				end
				for _, config in next, self.options["Config List"].values do
					if not table.find(Configs, config) then
						self.options["Config List"]:RemoveValue(config)
					end
				end
			end
		end)

		for _, tab in next, self.tabs do
			if tab.canInit then
				tab:Init()
				self:selectTab(tab)
			end
		end

		self:AddConnection(inputService.InputEnded, function(input)
			if input.UserInputType.Name == "MouseButton1" and self.slider then
				self.slider.slider.BorderColor3 = Color3.new()
				self.slider = nil
			end
		end)

		self:AddConnection(inputService.InputChanged, function(input)
			if not self.open then return end
			
			if input.UserInputType.Name == "MouseMovement" then
				if self.cursor then
					local mouse = inputService:GetMouseLocation()
					local MousePos = Vector2.new(mouse.X, mouse.Y)
					self.cursor.PointA = MousePos
					self.cursor.PointB = MousePos + Vector2.new(12, 12)
					self.cursor.PointC = MousePos + Vector2.new(12, 12)
					self.cursor1.PointA = MousePos
					self.cursor1.PointB = MousePos + Vector2.new(11, 11)
					self.cursor1.PointC = MousePos + Vector2.new(11, 11)
				end
				if self.slider then
					self.slider:SetValue(self.slider.min + ((input.Position.X - self.slider.slider.AbsolutePosition.X) / self.slider.slider.AbsoluteSize.X) * (self.slider.max - self.slider.min))
				end
			end
			if input == dragInput and dragging and library.draggable then
				local delta = input.Position - dragStart
				local yPos = (startPos.Y.Offset + delta.Y) < -36 and -36 or startPos.Y.Offset + delta.Y
				dragObject:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, yPos), "Out", "Quint", 0.1, true)
			end
		end)

		local Old_index
		Old_index = hookmetamethod(game, "__index", function(t, i)
			if checkcaller() then return Old_index(t, i) end

			if library and i == "MouseIconEnabled" then
				return library.mousestate
			end

			return Old_index(t, i)
		end)

		local Old_new
		Old_new = hookmetamethod(game, "__newindex", function(t, i, v)
			if checkcaller() then return Old_new(t, i, v) end

			if library and i == "MouseIconEnabled" then
				library.mousestate = v
				if library.open then return end
			end

			return Old_new(t, i, v)
		end)

		if not getgenv().silent then
			delay(1, function() self:Close() end)
		end
	end

	library.SettingsTab = library:AddTab("Settings", 100)
	library.SettingsColumn = library.SettingsTab:AddColumn()
	library.SettingsColumn1 = library.SettingsTab:AddColumn()

	library.SettingsMain = library.SettingsColumn:AddSection"Main"
	library.SettingsMain:AddButton({text = "Unload Cheat", nomouse = true, callback = function()
		library:Unload()
		getgenv().uwuware = nil
	end})
	library.SettingsMain:AddBind({text = "Panic Key", callback = library.options["Unload Cheat"].callback})

	library.SettingsMenu = library.SettingsColumn:AddSection"Menu"
	library.SettingsMenu:AddBind({text = "Open / Close", flag = "UI Toggle", nomouse = true, key = "Insert", callback = function() library:Close() end})
	library.SettingsMenu:AddColor({text = "Accent Color", flag = "Menu Accent Color", color = Color3.fromRGB(255, 65, 65), callback = function(Color)
		if library.currentTab then
			library.currentTab.button.TextColor3 = Color
		end
		for _, obj in next, library.theme do
			obj[(obj.ClassName == "TextLabel" and "TextColor3") or (obj.ClassName == "ImageLabel" and "ImageColor3") or "BackgroundColor3"] = Color
		end
	end})
	local Backgrounds = {
		["Floral"] = 5553946656,
		["Flowers"] = 6071575925,
		["Circles"] = 6071579801,
		["Hearts"] = 6073763717,
		["Polka dots"] = 6214418014,
		["Mountains"] = 6214412460,
		["Zigzag"] = 6214416834,
		["Zigzag 2"] = 6214375242,
		["Tartan"] = 6214404863,
		["Roses"] = 6214374619,
		["Hexagons"] = 6214320051,
		["Leopard print"] = 6214318622
	}
	library.SettingsMenu:AddList({text = "Background", flag = "UI Background", max = 6, values = {"Floral", "Flowers", "Circles", "Hearts", "Polka dots", "Mountains", "Zigzag", "Zigzag 2", "Tartan", "Roses", "Hexagons", "Leopard print"}, callback = function(Value)
		if Backgrounds[Value] then
			library.main.Image = "rbxassetid://" .. Backgrounds[Value]
		end
	end}):AddColor({flag = "Menu Background Color", color = Color3.new(), callback = function(Color)
		library.main.ImageColor3 = Color
	end, trans = 1, calltrans = function(Value)
		library.main.ImageTransparency = 1 - Value
	end})
	library.SettingsMenu:AddSlider({text = "Tile Size", value = 90, min = 50, max = 500, callback = function(Value)
		library.main.TileSize = UDim2.new(0, Value, 0, Value)
	end})

	library.ConfigSection = library.SettingsColumn1:AddSection"Configs"
	library.ConfigSection:AddBox({text = "Config Name", skipflag = true})
	library.ConfigSection:AddButton({text = "Create", callback = function()
		library:GetConfigs()
		writefile(library.foldername .. "/" .. library.flags["Config Name"] .. library.fileext, "{}")
		library.options["Config List"]:AddValue(library.flags["Config Name"])
	end})
	library.ConfigWarning = library:AddWarning({type = "confirm"})
	library.ConfigSection:AddList({text = "Configs", skipflag = true, value = "", flag = "Config List", values = library:GetConfigs()})
	library.ConfigSection:AddButton({text = "Save", callback = function()
		local r, g, b = library.round(library.flags["Menu Accent Color"])
		library.ConfigWarning.text = "Are you sure you want to save the current settings to config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
		if library.ConfigWarning:Show() then
			library:SaveConfig(library.flags["Config List"])
		end
	end})
	library.ConfigSection:AddButton({text = "Load", callback = function()
		local r, g, b = library.round(library.flags["Menu Accent Color"])
		library.ConfigWarning.text = "Are you sure you want to load config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
		if library.ConfigWarning:Show() then
			library:LoadConfig(library.flags["Config List"])
		end
	end})
	library.ConfigSection:AddButton({text = "Delete", callback = function()
		local r, g, b = library.round(library.flags["Menu Accent Color"])
		library.ConfigWarning.text = "Are you sure you want to delete config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
		if ConfigWarning:Show() then
			local Config = library.flags["Config List"]
			if table.find(library:GetConfigs(), Config) and isfile(library.foldername .. "/" .. Config .. library.fileext) then
				library.options["Config List"]:RemoveValue(Config)
				delfile(library.foldername .. "/" .. Config .. library.fileext)
			end
		end
	end})
	--LIBRARY END
	
	--custom notification thing, library required for this to work
	local LastNotification = 0
	function library:SendNotification(duration, message)
		LastNotification = LastNotification + tick()
		if LastNotification < 0.2 or not library.base then return end
		LastNotification = 0
		if duration then
			duration = tonumber(duration) or 2
			duration = duration < 2 and 2 or duration
		else
			duration = message
		end
		message = message and tostring(message) or "Empty"

		--create the thing
		local notification = library:Create("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			Size = UDim2.new(0, 0, 0, 80),
			Position = UDim2.new(1, -5, 1, -5),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderColor3 = Color3.fromRGB(20, 20, 20),
			Parent = library.base
		})
		tweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 80), BackgroundTransparency = 0}):Play()

		tweenService:Create(library:Create("TextLabel", {
			Position = UDim2.new(0, 5, 0, 25),
			Size = UDim2.new(1, -10, 0, 40),
			BackgroundTransparency = 1,
			Text = tostring(message),
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 18,
			TextTransparency = 1,
			TextWrapped = true,
			Parent = notification
		}), TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3), {TextTransparency = 0}):Play()

		--bump existing notifications
		for _,notification in next, library.notifications do
			notification:TweenPosition(UDim2.new(1, -5, 1, notification.Position.Y.Offset - 85), "Out", "Quad", 0.2)
		end
		library.notifications[notification] = notification

		wait(0.4)

		--create other things
		library:Create("Frame", {
			Position = UDim2.new(0, 0, 0, 20),
			Size = UDim2.new(0, 0, 0, 1),
			BackgroundColor3 = Color3.fromRGB(255, 65, 65),
			BorderSizePixel = 0,
			Parent = notification
		}):TweenSize(UDim2.new(1, 0, 0, 1), "Out", "Linear", duration)

		tweenService:Create(library:Create("TextLabel", {
			Position = UDim2.new(0, 4, 0, 0),
			Size = UDim2.new(0, 70, 0, 16),
			BackgroundTransparency = 1,
			Text = "uwuware",
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(255, 65, 65),
			TextSize = 16,
			TextTransparency = 1,
			Parent = notification
		}), TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

		--remove
		delay(duration, function()
			if not library then return end
			library.notifications[notification] = nil
			--bump existing notifications down
			for _,otherNotif in next, library.notifications do
				if otherNotif.Position.Y.Offset < notification.Position.Y.Offset then
					otherNotif:TweenPosition(UDim2.new(1, -5, 1, otherNotif.Position.Y.Offset + 85), "Out", "Quad", 0.2)
				end
			end
			notification:Destroy()
		end)
	end

	local GameTitle = ""
	local GameList = {
		["Counter Blox"] = 115797356,
		["Arsenal"] = 111958650,
		["Bad Business"] = 1168263273,
		--["Sound Space"] = 964540701,
		["Island Royale"] = 1320186298,
		--["Strucid"] = 833423526,
		["Unit: Classified"] = 4292776423,
		["Phantom Forces"] = 113491250,
		--["Apocalypse Rising 2"] = 1,
		["Operation Scorpion"] = 571399053,
		["Q-Clash!"] = 715769634,
		--["Future Tops"] = 656683441,
		--["Jailbreak"] = 245662005,
		["MURDER"] = 1484197505,
		["Ace Of Spadez"] = 913400159,
		["KAT"] = 254394801,
		["MMC Zombies Project"] = 410307227,
		["Recoil"] = 1534453623,
		["Project Lazarus"] = 169302362,
		["State Of Anarchy"] = 595270616,
		--["Hedgerows"] = 1631887111,
		--["Notoriety"] = 16680835,
		["Zombie Rush"] = 63955796,
		["Zombie Attack"] = 504035427,
		--["Infection"] = 1457889951,
		["Resurrection"] = 298118708,
		--["Typical Colors 2"] = 147332621,
		--["Blackhawk Rescue Mission"] = 5321709389,
		["Shoot Out"] = 1581656817,
		["Weaponry"] = 3297964905,
		["Citadel Of Adun"] = 4790960806,
		["Dust"] = 1944529780,
		--sadrad
		["Boxing Simulator"] = 4058282580,
		["BIG Paintball"] = 3527629287,
		["Giant Survival"] = 4003872968,
		--["Lumberjack Legends"] = 4379619839,
		--["Magnet Simulator"] = 3486025575,
		["Death Zone"] = 1069365631,
		["R2DA"] = 1772081673,
		["Zombie Uprising"] = 1709832923
	}
	for Name,ID in next, GameList do
		if game.GameId == ID then
			GameTitle = Name
		elseif game.PlaceId == ID then
			GameTitle = Name
		end
	end

	--Compatibility functions
	local function mouse1click(delay) spawn(function() mouse1press() wait(delay or 0.1) mouse1release() end) end
	local function mouse2click(delay) spawn(function() keypress(0x02) wait(delay or 0.1) keprelease(0x02) end) end
	local function keytap(key, delay) spawn(function() keypress(key) wait(delay or 0.1) keyrelease(key) end) end

	--Variables
	local RepStorage = game:GetService"ReplicatedStorage"
	local PlayerServ = game:GetService"Players"
	local Client = PlayerServ["LocalPlayer"]
	local Mouse = Client:GetMouse()
	local Settings = settings()
	local Players = {}
	local Camera = workspace.CurrentCamera
	local WTSP = Camera.WorldToScreenPoint
	local WTVP = Camera.WorldToViewportPoint
	local CameraSpoof = {
		FieldOfView = Camera.FieldOfView
	}
	local Lighting = game:GetService"Lighting"
	local LightingSpoof = {
		ClockTime = Lighting.ClockTime,
		Brightness = Lighting.Brightness,
		Ambient = Lighting.Ambient,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		ColorShift_Top = Lighting.ColorShift_Top,
	}
	local NameRequest
	local TeamRequest
	local HealthRequest
	local ClientCharRequest
	local Cowboys, Sheriffs = {}, {}
	local FFC = workspace.FindFirstChild
	local GBB = workspace.GetBoundingBox
	local FFA = workspace.FindFirstAncestor
	local FFCoC = workspace.FindFirstChildOfClass
	local V3Empty = Vector3.new()
	local V3101 = Vector3.new(1, 0, 1)
	local V2Empty = Vector2.new()
	local V211 = Vector2.new(1, 1)
	local V222 = Vector2.new(2, 2)
	local V233 = Vector2.new(3, 3)

	local UniversalBodyParts = {
		"Head",
		"UpperTorso", "LowerTorso", "Torso",
		"Left Arm", "LeftUpperArm", "LeftLowerArm", "LeftHand",
		"Right Arm", "RightUpperArm", "RightLowerArm", "RightHand",
		"Left Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
		"Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot"
	}
	local BBBodyParts = {
		"Head", "Neck",
		"Chest", "Abdomen", "Hips",
		"LeftHand", "LeftArm", "LeftForearm",
		"RightHand", "RightArm", "RightForearm",
		"LeftFoot", "LeftLeg", "LeftForeleg",
		"RightFoot", "RightLeg", "RightForeleg"
	}
	local R6BodyParts = {"Head","Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
	local AOSBodyParts = {
		"Head",
		"Shoulders", "Torso", "UpperTorso", "MidTorso", "LowerTorso",
		"UpperLeftArm", "LowerLeftArm", "LeftHandle",
		"UpperLeftLeg", "LowerLeftLeg", "LeftFoot",
		"UpperRightArm", "LowerRightArm", "RightHandle",
		"UpperRightLeg", "LowerRightLeg", "RightFoot"
	}
	local SOABodyParts = {
		"Head",
		"Base",
		"LeftArmUpper", "LeftArmMid", "LeftArmLower",
		"RightArmUpper", "RightArmMid", "RightArmLower",
		"LeftLegUpper", "LeftLegMid", "LeftLegLower",
		"RightLegUpper", "RighLegMid", "RightLegLower",
	}
	local UseBodyParts = GameTitle == "Bad Business" and BBBodyParts or GameTitle == "Phantom Forces" and R6BodyParts or GameTitle == "Ace Of Spadez" and AOSBodyParts or GameTitle == "State Of Anarchy" and SOABodyParts or UniversalBodyParts

	--Get functions
	local function GetHitboxFromChar(Character, BodyPart)
		BodyPart = BodyPart or "Head"
		if not Character then return end
		if GameTitle == "Bad Business" then
			return FFC(Character.Body, BodyPart) or FFC(Character.Body, "Chest")
		elseif GameTitle == "Project Lazarus" then
			BodyPart = BodyPart == "Head" and "HeadBox" or "Torso"
			return FFC(Character, BodyPart)
		else
			return FFC(Character, BodyPart) or FFC(Character, "UpperTorso")
		end
	end

	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Blacklist
	RayParams.IgnoreWater = true
	local function RayCheck(ClientChar, To, Distance)
		local Ignores = {Camera, ClientChar}
		if GameTitle == "Bad Business" then
			Ignores[3] = FFC(workspace, "Arms")
			--Ignores[#Ignores + 1] = ClientChar and FFC(workspace, ClientChar.Backpack.Equipped.Value.Name)
			Ignores[4] = workspace.NonProjectileGeometry
			Ignores[5] = workspace.Effects
			Ignores[6] = workspace.Spawns
			Ignores[7] = workspace.Ragdolls
			Ignores[8] = workspace.Gameplay
			Ignores[9] = workspace.Throwables
		elseif GameTitle == "Phantom Forces" then
			Ignores[3] = workspace.Ignore
		end
		RayParams.FilterDescendantsInstances = Ignores
		return workspace:Raycast(Camera.CFrame.p, (To - Camera.CFrame.p).Unit * Distance, RayParams)
	end

	local Sub = Vector3.new(-0.1, -0.1, -0.1)
	local function GetCorners(Object, Esp)
		local CF = Object.CFrame
		local Size = (Object.Size / 2)
		Size = Esp and Size or Size - Sub
		return {
			Vector3.new(CF.X+Size.X, CF.Y+Size.Y, CF.Z+Size.Z);
			Vector3.new(CF.X-Size.X, CF.Y+Size.Y, CF.Z+Size.Z);

			Vector3.new(CF.X-Size.X, CF.Y-Size.Y, CF.Z-Size.Z);
			Vector3.new(CF.X+Size.X, CF.Y-Size.Y, CF.Z-Size.Z);

			Vector3.new(CF.X-Size.X, CF.Y+Size.Y, CF.Z-Size.Z);
			Vector3.new(CF.X+Size.X, CF.Y+Size.Y, CF.Z-Size.Z);

			Vector3.new(CF.X-Size.X, CF.Y-Size.Y, CF.Z+Size.Z);
			Vector3.new(CF.X+Size.X, CF.Y-Size.Y, CF.Z+Size.Z);
		}
	end

	--Player data
	local ESPObjects = {}

	local function Track(Player)
		-- too lazy to add a proper check, discontinued anyway so
		if not (Player.ClassName == "Player" or Player.ClassName == "Folder") then return end

		for i,v in next, ESPObjects do
			if not v.Active then
				v.Active = true
				ESPObjects[Player] = v
				break
			end
		end
		if not ESPObjects[Player] then
			ESPObjects[Player] = {
				ChamsOutline = library:Create("Folder", {Parent = library.base}),
				Chams = library:Create("Folder", {Parent = library.base}),
				ChamsStep = 0,
				BoxOutline = library:Create("Square", {Thickness = 1}),
				BoxInline = library:Create("Square", {Thickness = 1}),
				Box = library:Create("Square", {Thickness = 1}),
				LookAt = library:Create("Line", {Thickness = 1}),
				NameText = library:Create("Text", {Size = 15, Font = 3, Center = true, Outline = true}),
				DistanceText = library:Create("Text", {Size = 15, Font = 3, Center = true, Outline = true}),
				BarOutline = library:Create("Square", {Filled = true}),
				Bar = library:Create("Square", {Filled = true}),
				HealthText = library:Create("Text", {Color = Color3.new(1, 1, 1), Size = 14, Font = 3, Center = true, Outline = true}),
				DirectionLine = library:Create("Line", {Thickness = 1}),
				DirectionDot = library:Create("Square", {Size = Vector2.new(7, 7), Filled = true}),
				--RadarHeight = library:Create("TextLabel", {BackgroundTransparency = 1, Text = "T", TextColor3 = Color3.new(), Font = Enum.Font.SciFi, TextSize = 13}),
				RadarBlip = library:Create("Circle", {Radius = 4, Filled = true}),
				OOVArrow = library:Create"Triangle",
				Active = true,

				Invis = function()
					ESPObjects[Player].Visible = false
					ESPObjects[Player].BoxOutline.Visible = false
					ESPObjects[Player].BoxInline.Visible = false
					ESPObjects[Player].Box.Visible = false
					ESPObjects[Player].BarOutline.Visible = false
					ESPObjects[Player].Bar.Visible = false
					ESPObjects[Player].HealthText.Visible = false
					ESPObjects[Player].LookAt.Visible = false
					ESPObjects[Player].NameText.Visible = false
					ESPObjects[Player].DistanceText.Visible = false
					ESPObjects[Player].DirectionLine.Visible = false
					ESPObjects[Player].DirectionDot.Visible = false
				end,

				InvisChams = function()
					ESPObjects[Player].ChamsVisible = false
					for _, Cham in next, ESPObjects[Player].Chams:GetChildren() do
						Cham.Transparency = 1
					end
				end,

				InvisChamsOutline = function()
					ESPObjects[Player].ChamsOutlineVisible = false
					for _, Cham in next, ESPObjects[Player].ChamsOutline:GetChildren() do
						Cham.Transparency = 1
					end
				end,

				InvisRadar = function()
					ESPObjects[Player].RadarVisible = false
					ESPObjects[Player].RadarBlip.Visible = false
				end
			}
		end

		local Character
		local MaxHealth
		Players[Player] = setmetatable({Priority = false, Whitelist = false, LastPosition = V3Empty}, {__index = function(self, index)
			if index == "Character" then
				if Player.ClassName == "Model" then
					Character = Player
				else
					if GameTitle == "Phantom Forces" then
						if Player == Client then
							Character = Client.Character and FFC(Client.Character, "HumanoidRootPart") and Client.Character
						else
							if NameRequest[Player] and NameRequest[Player].torso then
								Character = NameRequest[Player].torso.Parent
							end
						end
					elseif GameTitle == "Bad Business" then
						Character = NameRequest[Player]
						Character = Character and Character.Parent == workspace.Characters and Character
					elseif GameTitle == "Operation Scorpion" then
						Character = FFC(Player, "Vars") and Player.Vars["isAlive"].Value and Player.Character
					elseif GameTitle == "Hedgerows" then
						Character = Player.Character and Player.Character.Parent and Player.Character
					elseif GameTitle == "Recoil" then
						Character = FFC(workspace, Player.Name)
					else
						Character = Player.Character or FFC(workspace, Player.Name)
						if Character then
							if GameTitle == "Arsenal" then
								Character = FFC(Character, "Spawned") and Character
							elseif GameTitle == "MURDER" then
								Character = FFC(Player, "Status") and Player.Status.Alive.Value and Character
							elseif GameTitle == "Ace Of Spadez" then
								Character = Character.Parent and Character.Parent.Name ~= "Spectators" and Character
							elseif GameTitle == "Q-Clash" then
								Character = FFCoC(Character, "BillboardGui", true)
							end
						end
					end
				end

				if Character then 
					if Player ~= Client and not library.flags["Aimbot Ignore Spawn Protection"] then
						if GameTitle == "Bad Business" then
							if FFC(Character, "ShieldEmitter", true) then
								if Character.Root.ShieldEmitter.Enabled then
									return
								end
							end
						elseif GameTitle ~= "Phantom Forces" then
							if FFC(Character, "ForceField") then
								return
							end
						end
					end
					return Character
				end
			else
				if not Character then return (index == "Health" or index == "MaxHealth" and 0) end
				if index == "Health" then
					local Health
					if GameTitle == "Bad Business" then
						Health, MaxHealth = FFC(Character, "Health") and Character.Health.Value, 150
					elseif GameTitle == "Phantom Forces" then
						Health, MaxHealth = HealthRequest:getplayerhealth(Player), 100
					elseif GameTitle == "MURDER" or GameTitle == "Arsenal" or GameTitle == "Unit: Classified" then
						Health, MaxHealth = FFC(Player, "NRPBS") and Player.NRPBS.Health.Value, Player.NRPBS.MaxHealth.Value
					--elseif GameTitle == "Q-Clash" then
					--	Health, MaxHealth = HealthRequest(Character)
					else
						local Humanoid = FFCoC(Character, "Humanoid")
						if Humanoid then
							Health, MaxHealth = Humanoid.Health, Humanoid.MaxHealth
						end
					end
					return Health and (Health > 0 and Health) or 0
				elseif index == "MaxHealth" then
					return MaxHealth or 0
				elseif index == "Enemy" then
					if Player.ClassName == "Model" then
						return GameTitle == "Blackhawk Rescue Mission" and (Player.Name:find("Infantry") and true or false) or true
					else
						if GameTitle == "Blackhawk Rescue Mission" or GameTitle == "R2DA" or GameTitle == "Resurrection" or GameTitle == "Project Lazarus" or GameTitle == "MMC Zombies Project" or GameTitle == "Zombie Rush" or GameTitle == "Zombie Attack" then
							return false
						elseif GameTitle == "Bad Business" then
							return TeamRequest({}, Client) ~= TeamRequest({}, Player) 
						elseif GameTitle == "Q-Clash!" then
							local ClientChar = Client.Character
							return Character and ClientChar and Character.Parent ~= ClientChar.Parent
						elseif GameTitle == "Recoil" then
							return FFC(Player, "GameStats") and Client.GameStats.Team.value ~= Player.GameStats.Team.value
						elseif GameTitle == "Shoot Out" then
							return (Cowboys[Client] and Cowboys or Sheriffs) ~= (Cowboys[Player] and Cowboys or Sheriffs)
						else
							if Client.Team then
								return Client.Team ~= Player.Team
							else
								return true
							end
						end
					end
				end
			end

		end})
	end

	local function AddTracker(Tracking)
		for _,Player in next, Tracking:GetChildren() do
			if GameTitle == "Blackhawk Rescue Mission" then
				if Tracking == PlayerServ then
					Track(Player)
				else
					if Player.Name:find("Infantry") or Player.Name:find("Civilian") then
						Track(Player)
					end
				end
			else
				Track(Player)
			end
		end

		library:AddConnection(Tracking.ChildAdded, function(Player)
			wait(1)
			if Tracking == PlayerServ and library then
				library.options["Player List"]:AddValue(Player.Name)
			end
			if GameTitle == "Blackhawk Rescue Mission" then
				if Tracking == PlayerServ then
					Track(Player)
				else
					if Player.Name:find"Infantry" or Player.Name:find"Civilian" then
						Track(Player)
					end
				end
			else
				Track(Player)
			end
		end)

		library:AddConnection(Tracking.ChildRemoved, function(Player)
			if Players[Player] then
				if table.find(library.options["Player List"].values, Player.Name) then
					if library.hasInit then
						library.options["Player List"]:RemoveValue(Player.Name)
					end
				end
				Players[Player] = nil
				if ESPObjects[Player] then
					ESPObjects[Player].Active = false
					ESPObjects[Player].OOVArrow.Visible = false
					ESPObjects[Player].Invis()
					ESPObjects[Player].InvisChams()
					ESPObjects[Player].InvisChamsOutline()
					ESPObjects[Player].InvisRadar()
				end
			end
		end)
	end

	library:AddConnection(workspace.ChildAdded, function(Obj)
		if Obj.ClassName == "Camera" then
			Camera = Obj
			WTSP = Obj.WorldToScreenPoint
			WTVP = Obj.WorldToViewportPoint
		end
	end)

	--UI
	--local RadarWindow = library:Create("Circle", {NumSides = 64, Radius = 100, Filled = true, Color = Color3.fromRGB(30, 30, 30)})
	local Draw = library:Create("Circle", {NumSides = 64, Thickness = 1})

	local CrosshairTop = library:Create("Square", {Filled = true})
	local CrosshairLeft = library:Create("Square", {Filled = true})
	local CrosshairRight = library:Create("Square", {Filled = true})
	local CrosshairBottom = library:Create("Square", {Filled = true})

	--Aimbot Module
	local AimbotRayParams = RaycastParams.new()
	AimbotRayParams.FilterType = Enum.RaycastFilterType.Whitelist
	AimbotRayParams.IgnoreWater = true

	local AimbotHitboxes = {}

	library.Aimbot = {
		Target = nil,
		Player = nil,
		Distance = nil,
		Position = nil,
		Position3d = nil,
		LastPosition = V3Empty,
		PositionOffset = nil,
		PositionOffset2d = nil,
		Part = nil,
		OnScreen = false,
		LastVisible = false,
		Step = 0,
		OldStep = 0,
		AutoShootStep = 0
	}

	library.Aimbot.Reset = function()
		library.Aimbot.Target = nil
		library.Aimbot.Player = nil
		library.Aimbot.Distance = 9e9
		library.Aimbot.Position = nil
		library.Aimbot.Position3d = nil
		library.Aimbot.LastPosition = V3Empty
		library.Aimbot.PositionOffset = nil
		library.Aimbot.PositionOffset2d = nil
		library.Aimbot.Part = nil
		library.Aimbot.OnScreen = false
		library.Aimbot.LastVisible = false
		library.Aimbot.Step = 0
		library.Aimbot.SwitchStep = 0
		library.Aimbot.AutoShootStep = 0
	end

	library.Aimbot.Check = function(Player, Steady, Step)
		if not Players[Player] then return end
		local Character, ClientChar = Players[Player].Character, Players[Client].Character
		if Players[Player].Health > 0.1 and Character and ClientChar then
			local MX, MY = Mouse.X, Mouse.Y
			if library.flags["Mouse Offset"] then
				MX = MX + library.flags["MXO Amount"]
				MY = MY + library.flags["MYO Amount"]
			end

			local Target
			local OldDist = 9e9
			if library.flags["Aimbot Randomize Hitbox"] then
				if library.Aimbot.Part then
					Target = GetHitboxFromChar(Character, library.Aimbot.Part)
				else
					if not Target then
						local PartName = AimbotHitboxes[math.random(1, #AimbotHitboxes)]
						Target = GetHitboxFromChar(Character, PartName)
						library.Aimbot.Part = PartName
					end
				end
			else
				for i,v in next, library.flags["Aimbot Hitboxes"] do
					if not v then continue end

					local Part = GetHitboxFromChar(Character, i)
					if not Part then continue end

					local ScreenPos = WTSP(Camera, Part.Position)
					local Dist = (Vector2.new(MX, MY) - Vector2.new(ScreenPos.X, ScreenPos.Y)).Magnitude

					if Dist > OldDist then continue end

					OldDist = Dist
					Target = Part			
				end
			end
			if not Target then return end

			local Position, OnScreen = WTSP(Camera, Target.Position)
			if library.flags["Aimbot Mode"] ~= "Silent" then
				if not OnScreen then
					return
				end
			end

			local DistanceFromCharacter = (Target.Position - Camera.CFrame.p).Magnitude
			if DistanceFromCharacter > library.flags["Aimbot Max Distance"] then return end

			local DistanceFromMouse = (Vector2.new(MX, MY) - Vector2.new(Position.X, Position.Y)).Magnitude
			if library.flags["Use FOV"] then
				local FoVSize = library.flags["FOV Size"]
				if DistanceFromMouse > FoVSize + (library.flags["Dynamic FOV"] and ((120 - Camera.FieldOfView) * 4) or FoVSize) then
					return
				end
			end

			local Hit
			if library.flags["Aimbot Vis Check"] or library.flags["Auto Shoot"] or library.flags["Aimbot Prioritize"] then
				Hit = RayCheck(ClientChar, Target.Position, library.flags["Aimbot Max Distance"])
				Hit = Hit and Hit.Instance and FFA(Hit.Instance, Character.Name) == Character
				if Hit then
					if library.flags["Auto Shoot"] then
						library.Aimbot.AutoShootStep = library.Aimbot.AutoShootStep + Step
						if library.Aimbot.AutoShootStep > library.flags["Auto Shoot Interval"] * 0.001 then
							library.Aimbot.AutoShootStep = 0
							if library.flags["Aimbot Mode"] == "Silent" then
								mouse1click()
							else
								AimbotRayParams.FilterDescendantsInstances = {Character}
								local Pos = Camera.CFrame.p
								if workspace:Raycast(Pos, (Camera:ScreenPointToRay(MX, MY, 10000).Origin - Pos).Unit * library.flags["Aimbot Max Distance"], AimbotRayParams) then
									mouse1click()
								end
							end
						end
					end
				else
					if library.flags["Aimbot Vis Check"] then
						return
					end
					if library.flags[GameTitle .. " Wallbang"] and library.flags["Auto Shoot"] then
						library.Aimbot.AutoShootStep = library.Aimbot.AutoShootStep + Step
						if library.Aimbot.AutoShootStep > library.flags["Auto Shoot Interval"] * 0.001 then
							library.Aimbot.AutoShootStep = 0
							mouse1click()
						end
					end
				end
			end

			library.Aimbot.PositionOffset = library.Aimbot.PositionOffset or V3Empty
			library.Aimbot.PositionOffset2d = library.Aimbot.PositionOffset2d or V3Empty
			if library.flags["Velocity Prediction"] then
				local Diff = (Target.Position - library.Aimbot.LastPosition)
				if Diff.Magnitude > (library.flags["Aimbot Mode"] == "Legit" and 0.05 or 0.01) then
					library.Aimbot.PositionOffset = Diff.Unit * library.flags["Velocity Prediction Multiplier"]
					library.Aimbot.PositionOffset2d = WTSP(Camera, Target.Position + library.Aimbot.PositionOffset) - Position
				else
					library.Aimbot.PositionOffset = V3Empty
					library.Aimbot.PositionOffset2d = V3Empty
				end
			end

			if Players[Player].Priority then
				library.Aimbot.Target = Target
				library.Aimbot.Player = Player
				library.Aimbot.Position3d = Target.Position + library.Aimbot.PositionOffset
				library.Aimbot.Position = Position + library.Aimbot.PositionOffset2d
				library.Aimbot.OnScreen = OnScreen
				return true
			end

			if not Steady then
				if library.flags["Aimbot Priority"] == "Mouse" then
					if DistanceFromMouse <= library.Aimbot.Distance then
						library.Aimbot.Distance = DistanceFromMouse
					else
						return
					end
				else
					if DistanceFromCharacter <= library.Aimbot.Distance then
						library.Aimbot.Distance = DistanceFromCharacter
					else
						return
					end
				end
			end

			if library.flags["Aimbot Prioritize"] then
				if not Hit then
					if library.Aimbot.LastVisible then
						return
					end
				end
			end

			library.Aimbot.Target = Target
			library.Aimbot.Player = Player
			library.Aimbot.Position3d = Target.Position + library.Aimbot.PositionOffset
			library.Aimbot.Position = Position + library.Aimbot.PositionOffset2d
			library.Aimbot.OnScreen = OnScreen
			return true
		end
	end

	library.Aimbot.Run = function(Step)
		if library.Aimbot.Check(library.Aimbot.Player, true, Step) then
			if library.flags["Aimbot Mode"] == "Legit" then
				local AimAtX, AimAtY = library.Aimbot.Position.X, library.Aimbot.Position.Y
				local MX, MY = Mouse.X, Mouse.Y

				if library.flags["Mouse Offset"] then
					MX = MX + library.flags["MXO Amount"]
					MY = MY + library.flags["MYO Amount"]
				end

				AimAtX, AimAtY = AimAtX - MX, AimAtY - MY

				--local MinDist = 10
				--local mouseSens = UserSettings():GetService"UserGameSettings".MouseSensitivity
				local Smoothness = library.flags["Aimbot Smoothness"]
				if library.flags["Aimbot Snap"] then
					if math.abs(AimAtX) >= Smoothness or math.abs(AimAtY) >= Smoothness then
						AimAtX = AimAtX / Smoothness
						AimAtY = AimAtY / Smoothness
					end
				else
					if Smoothness > 1 then
						AimAtX = AimAtX / Smoothness
						AimAtY = AimAtY / Smoothness
					end
				end

				mousemoverel(AimAtX, AimAtY)
			end

			library.Aimbot.LastPosition = library.Aimbot.Target.Position
			if library.flags["Aim Lock"] then
				return
			end
		else
			library.Aimbot.Reset()
		end
		library.Aimbot.SwitchStep = library.Aimbot.SwitchStep + Step
		if library.Aimbot.Player then
			if library.Aimbot.SwitchStep < library.flags["Aimbot Switch Delay"] * 0.001 then return end
		end
		library.Aimbot.SwitchStep = 0
		library.Aimbot.Distance = 9e9
		for Player, Data in next, Players do
			if Player == Client or Data.Whitelist then continue end
			if (library.flags["Aimbot At Teammates"] or Data.Enemy) then
				if library.Aimbot.Check(Player, false, 0) and Data.Priority then
					break
				end
			end
		end
	end

	local TriggerStep = 0
	local function RunTriggerbot()
		local ClientChar = Players[Client].Character
		if not ClientChar then return end
		for _, Data in next, Players do
			local Character = Data.Character
			if Character and (library.flags["Triggerbot Teammates"] or Data.Enemy) then
				local MX, MY = Mouse.X, Mouse.Y
				if library.flags["Mouse Offset"] then
					MX = MX + library.flags["MXO Amount"]
					MY = MY + library.flags["MYO Amount"]
				end
				local Hit = RayCheck(ClientChar, Camera:ScreenPointToRay(MX, MY, 2000).Origin, 2000)
				if Hit and Hit.Instance then
					if library.flags["Triggerbot Hitbox"] == "Character" and Hit.Instance:IsDescendantOf(Character) or Hit.Instance.Name == library.flags["Triggerbot Hitbox"] then
						--if library.flags["Triggerbot Magnet"] then
						--	local ScreenPos = WTSP(Camera, Hit.Instance.Position)
						--	local AimAtX, AimAtY = (ScreenPos.X - Mouse.X) - MX, (ScreenPos.Y - Mouse.Y) - MY
						--	mousemoverel(AimAtX, AimAtY)
						--end
						--print"click"
						mouse1click()
					end
				end
			end
		end
	end

	local AimbotTab = library:AddTab"Aimbot"
	local AimbotColumn = AimbotTab:AddColumn()
	local AimbotColumn1 = AimbotTab:AddColumn()

	local AimbotMain = AimbotColumn:AddSection"Main"
	local AimbotTargeting = AimbotColumn:AddSection"Targeting"
	local AimbotMisc = AimbotColumn1:AddSection"Misc"
	local TriggerbotMain = AimbotColumn1:AddSection"Triggerbot"

	AimbotMain:AddToggle({text = "Enabled", flag = "Aimbot", callback = function(State)
		Draw.Visible = State and library.flags["Use FOV"] and library.flags["Draw Circle"]
		if library.flags["Aimbot Always On"] then
			library.options["Aimbot Always On"]:SetState(true)
		end
	end}):AddList({text = "Mode", flag = "Aimbot Mode", values = {"Legit", "Rage"}, callback = function(Value)
		library.options["Aimbot Smoothness"].main.Visible = Value == "Legit"
		library.options["Aimbot Snap"].main.Visible = Value == "Legit"
		library.options["Mouse Offset"].main.Visible = Value == "Legit"
		library.options["MXO Amount"].main.Visible = Value == "Legit" and library.flags["Mouse Offset"]
		library.options["MYO Amount"].main.Visible = Value == "Legit" and library.flags["Mouse Offset"]
	end}):AddBind({flag = "Aimbot Key", mode = "hold", callback = function(Ended, Step)
		if library.flags["Aimbot"] and not library.flags["Aimbot Always On"] then
			if library.open or Ended then
				library.Aimbot.Reset()
			else
				library.Aimbot.Step = library.Aimbot.Step + Step
				if library.Aimbot.Step > 0.016 then
					library.Aimbot.Step = 0
					library.Aimbot.Run(Step)
				end
			end
		end
	end})
	AimbotMain:AddToggle({text = "Always On", flag = "Aimbot Always On", callback = function(State)
		if not State then return end

		library:AddConnection(runService.RenderStepped, "Aimbot", function(Step)
			if library.open then library.Aimbot.Reset() return end
			if library.flags["Aimbot"] and library.flags["Aimbot Always On"] then
				library.Aimbot.Step = library.Aimbot.Step + Step
				if library.Aimbot.Step > 0.016 then
					library.Aimbot.Step = 0
					library.Aimbot.Run(Step)
				end
			else
				library.connections["Aimbot"]:Disconnect()
				library.Aimbot.Reset()
			end
		end)
	end})
	AimbotMain:AddSlider({text = "Smoothness", flag = "Aimbot Smoothness", min = 1, max = 40})
	AimbotMain:AddToggle({text = "Velocity Prediction", state = false, callback = function(State)
		library.options["Velocity Prediction Multiplier"].main.Visible = State
	end})
	AimbotMain:AddSlider({text = "Multiplier", textpos = 2, flag = "Velocity Prediction Multiplier", min = 1, max = 5, float = 0.1})
	--AimbotMain:AddSlider({text = "Prediction Interval", min = 1, max = 1000})
	AimbotMain:AddToggle({text = "Snap Near Target", flag = "Aimbot Snap"})--:AddSlider({text = "Snap Range" flag = "Aimbot Snap Range", min = 5, max = 50})
	--AimbotMain:AddToggle({text = "Curve", flag = "Aimbot Curve"}):AddSlider({text = "Size", flag = "Aimbot Curve Size", min = 1, max = 50})
	AimbotMain:AddToggle({text = "Lock Target", flag = "Aim Lock"})
	AimbotMain:AddToggle({text = "Auto Shoot", callback = function(State)
		library.options["Auto Shoot Interval"].main.Visible = State
		if State then
			library.options["Triggerbot"]:SetState()
		end
	end})
	AimbotMain:AddSlider({text = "Interval", textpos = 2, flag = "Auto Shoot Interval", min = 16, max = 1000, suffix = "ms"})
	--AimbotMain:AddToggle({text = "Randomization"})
	--AimbotMain:AddSlider({text = "Amount", flag = "Randomize Amount", min = 40, max = 100})
	AimbotMain:AddSlider({text = "Target Switch Delay", flag = "Aimbot Switch Delay", min = 16, max = 500, suffix = "ms"})
	AimbotMain:AddToggle({text = "Ignore Spawn Protection", flag = "Aimbot Ignore Spawn Protection"})

	AimbotTargeting:AddToggle({text = "Visible Only", flag = "Aimbot Vis Check", callback = function(State)
		if State then
			--library.options["Aimbot Prioritize"]:SetState()
		end
	end})
	--AimbotTargeting:AddToggle({text = "Prioritize Visible", flag = "Aimbot Prioritize", callback = function(State)
	--	if State then
	--		library.options["Aimbot Vis Check"]:SetState()
	--	end
	--end})
	AimbotTargeting:AddToggle({text = "At Teammates", flag = "Aimbot At Teammates"})
	AimbotTargeting:AddList({text = "Priority", flag = "Aimbot Priority", values = {"Mouse", "Distance"}})
	AimbotTargeting:AddList({text = "Hitboxes", flag = "Aimbot Hitboxes", max = 6, multiselect = true, values = UseBodyParts, callback = function(Values)
		for i,v in next, Values do
			if v then
				if table.find(AimbotHitboxes, i) then continue end
				table.insert(AimbotHitboxes, i)
			else
				local pos = table.find(AimbotHitboxes, i)
				if not pos then continue end
				table.remove(AimbotHitboxes, pos)
			end
		end
	end})
	AimbotTargeting:AddToggle({text = "Randomize Hitbox", flag = "Aimbot Randomize Hitbox"})

	AimbotTargeting:AddSlider({text = "Max Distance", flag = "Aimbot Max Distance", value = 10000, min = 0, max = 10000})

	AimbotMisc:AddToggle({text = "Mouse Offset", callback = function(State)
		if library.flags["Aimbot Mode"] == "Legit" then
			library.options["MXO Amount"].main.Visible = State
			library.options["MYO Amount"].main.Visible = State
		end
	end})
	AimbotMisc:AddSlider({text = "X", textpos = 2, flag = "MXO Amount", min = -100, max = 100, value = 0})
	AimbotMisc:AddSlider({text = "Y", textpos = 2, flag = "MYO Amount", min = -100, max = 100, value = 0})
	AimbotMisc:AddToggle({text = "Highlight Target"}):AddColor({flag = "Aimbot Highlight Color", color = Color3.fromRGB(240, 20, 255)})
	AimbotMisc:AddToggle({text = "Use FOV", callback = function(State) Draw.Visible = State and library.flags["Aimbot"] and library.flags["Draw Circle"] end}):AddSlider({text = "Size", flag = "FOV Size", min = 10, max = 300, callback = function(Value) if not library.flags["Dynamic FOV"] then Draw.Radius = Value * 2 end end})
	AimbotMisc:AddToggle({text = "Dynamic", flag = "Dynamic FOV", callback = function(State)
		if State then
			library:AddConnection(runService.RenderStepped, "Dynamic FOV", function()
				if library and library.flags["Dynamic FOV"] then
					Draw.Radius = library.flags["FOV Size"] + ((120 - Camera.FieldOfView) * 4)
				else
					library.connections["Dynamic FOV"]:Disconnect()
					Draw.Radius = library.flags["FOV Size"] * 2
				end
			end)
		end
	end})
	AimbotMisc:AddToggle({text = "Draw Circle", callback = function(State) Draw.Visible = State and library.flags["Aimbot"] and library.flags["Use FOV"] end}):AddColor({flag = "FOV Circle Color", Color3.fromRGB(240, 20, 255), trans = 1, callback = function(Color) Draw.Color = Color end, calltrans = function(Value) Draw.Transparency = Value end})
	AimbotMisc:AddToggle({text = "Fill", flag = "FOV Fill", callback = function(State) Draw.Filled = State end})

	TriggerbotMain:AddToggle({text = "Enabled", flag = "Triggerbot", callback = function(State)
		if State then
			library.options["Auto Shoot"]:SetState()
			if library.flags["Triggerbot Always On"] then
				library.options["Triggerbot Always On"]:SetState(true)
			end
		end
	end}):AddSlider({text = "Delay", flag = "Triggerbot Delay", min = 16, max = 1000, suffix = "ms"}):AddBind({flag = "Triggerbot Key", mode = "hold", callback = function(Ended, Step)
		if library.flags["Triggerbot"] and not library.flags["Triggerbot Always On"] then
			if not library.open then
				TriggerStep = TriggerStep + Step
				if TriggerStep > library.flags["Triggerbot Delay"] * 0.001 then
					TriggerStep = 0
					RunTriggerbot()
				end
			end
		end
	end})
	TriggerbotMain:AddToggle({text = "Always On", flag = "Triggerbot Always On", callback = function(State)
		if State then
			library:AddConnection(runService.RenderStepped, "Triggerbot", function(Step)
				if library.open then return end
				if library.flags["Triggerbot"] and library.flags["Triggerbot Always On"] then
					TriggerStep = TriggerStep + Step
					if TriggerStep > library.flags["Triggerbot Delay"] * 0.001 then
						TriggerStep = 0
						RunTriggerbot(Step)
					end
				else
					library.connections["Triggerbot"]:Disconnect()
				end
			end)
		end
	end})
	--TriggerbotMain:AddToggle({text = "Magnet", flag = "Triggerbot Magnet"})
	TriggerbotMain:AddList({text = "Hitbox", flag = "Triggerbot Hitbox", values = {"Head", "Torso", "Character"}})
	TriggerbotMain:AddToggle({text = "At Teammates", flag = "Triggerbot Teammates"})

	--Esp module

	local VisualsTab = library:AddTab"Visuals"
	local VisualsColumn = VisualsTab:AddColumn()
	local VisualsColumn1 = VisualsTab:AddColumn()

	local HealthBarAddon = Vector2.new(3)
	local PlayerEspSection = VisualsColumn:AddSection"ESP"
	local OldStep = 0
	PlayerEspSection:AddToggle({text = "Enabled", flag = "Esp Enabled", callback = function(State)
		if not State then
			--RadarWindow.Visible = false
			if library.connections["Player ESP"] then
				library.connections["Player ESP"]:Disconnect()
				for _, v in next, ESPObjects do
					v.OOVArrow.Visible = false
					v.Invis()
					v.InvisChams()
					v.InvisChamsOutline()
				end
			end

			return
		end

		--RadarWindow.Visible = library.flags["Radar Enabled"]
		library:AddConnection(runService.RenderStepped, "Player ESP", function(Step)
			OldStep = OldStep + Step
			if OldStep < 0.016 then return end
			OldStep = 0

			for Player, Data in next, Players do
				if Player == Client then continue end
				local Objects = ESPObjects[Player]
				local Character = Data.Character

				local Show
				local Team = Data.Enemy
				if Data.Whitelist then
					Show = library.flags["Esp Show Whitelisted"]
				else
					Show = Data.Priority or library.flags["Esp Enabled For"][Team and "Enemies" or "Teammates"]
				end

				if Show and Character then
					local Health = Data.Health

					if Health > 0.1 then
						Team = Team and "Enemy" or "Team"

						local Pos, Size = GBB(Character)
						local RootPart = FFC(Character, "HumanoidRootPart")
						if RootPart and (Pos.Position - RootPart.Position).Magnitude > 5 then
							Pos = RootPart.CFrame
						end

						local Distance = (Camera.CFrame.p - Pos.Position).Magnitude
						if Distance < library.flags["Esp Max Distance"] then

							local ScreenPosition, OnScreen = WTVP(Camera, Pos.Position)

							local ClientChar = Players[Client].Character
							local Ignores = {Camera, ClientChar}
							if GameTitle == "Bad Business" then
								Ignores[3] = FFC(workspace, "Arms")
								--Ignores[4] = ClientChar and FFC(workspace, ClientChar.Backpack.Equipped.Value.Name)
								Ignores[5] = workspace.NonProjectileGeometry
								Ignores[6] = workspace.Effects
								Ignores[7] = workspace.Spawns
								Ignores[8] = workspace.Ragdolls
								Ignores[9] = workspace.Gameplay
								Ignores[10] = workspace.Throwables
							elseif GameTitle == "Phantom Forces" then
								Ignores[3] = workspace.Ignore
							end
							local Hit = RayCheck(ClientChar, Pos.Position, Distance)
							Hit = Hit and Hit.Instance and FFA(Hit.Instance, Character.Name)
							Hit = Hit and Hit == Character
							local Occluded = Hit and " " or " Occluded "

							local Visible = true
							if library.flags[Team .. " Visible Only"] then
								Visible = Hit ~= nil
							end

							local Color = (library.flags["Highlight Target"] and library.Aimbot.Player == Player and library.flags["Aimbot Highlight Color"])
							Color = Color or (Data.Priority and library.flags["Player Priority Color"] or Data.Whitelist and library.flags["Player Whitelist Color"])
							Color = Color or (GameTitle == "KAT" and (workspace.Gamemode.Value == "Murder" and ((FFC(Player.Backpack, "Knife") or FFC(Character, "Knife")) and library.flags[GameTitle .. " Murderer Color"] or (FFC(Player.Backpack, "Revolver") or FFC(Character, "Revolver")) or library.flags[GameTitle .. " Sheriff Color"])) or GameTitle == "MURDER" and ((Player.Status.Role.Value == "Murderer" and library.flags[GameTitle .. " Murderer Color"]) or (Player.Status.HasRevolver.Value and library.flags[GameTitle .. " Detective Color"])) or GameTitle == "Arsenal" and Player.NRPBS.EquippedTool.Value:find("Golden") and library.flags[GameTitle .. " Golden Weapon Color"])

							--
							if library.flags["Radar Enabled"] and Distance < RadarWindow.Radius then
								Objects.RadarBlip.Visible = true

								local RelativePos = Camera.CFrame:Inverse() * Pos.Position
								local Middle = Camera.ViewportSize / 2
								local Degrees = math.deg(math.atan2(-RelativePos.Y, RelativePos.X)) * math.pi / 180
								local EndPos = Middle + (Vector2.new(math.cos(Degrees), math.sin(Degrees)) * Distance)

								Objects.RadarBlip.Position = EndPos
								Objects.RadarBlip.Color = Color or Color3.new(1, 1, 1)

								if not Objects.Visible then
									continue
								end
							else
								Objects.RadarBlip.Visible = false
							end
							--]]

							if Visible then
								local Transparency = (library.Aimbot.Player == Player or Data.Priority) and 1 or 1 - (Distance / library.flags["Esp Max Distance"])

								if OnScreen then
									Objects.Visible = true
									Objects.OOVArrow.Visible = false

									--local xMin, yMin = 9e9, 9e9
									--local xMax, yMax = 0, 0

									local BoxColor = Color or library.flags[Team .. Occluded .. "Box Color"]
									local TextColor = Color or library.flags[Team .. Occluded .. "Info Color"]
									local LookColor = Color or library.flags[Team .. Occluded .. "Look Color"]
									local ChamsColor = Color or library.flags[Team .. Occluded .. "Chams Color"]
									local ChamsOutlineColor = Color or library.flags[Team .. Occluded .. "Chams Outline Color"]
									local DirectionColor = Color or library.flags[Team .. Occluded .. "Direction Color"]

									--Chams
									if library.flags[Team .. " Chams Enabled"] and Distance < 600 then
										Objects.ChamsVisible = true
										Objects.Chams.Parent = library.base
										Objects.ChamsStep = Objects.ChamsStep + Step
										if Objects.ChamsStep > 0.2 then
											Objects.ChamsStep = 0
											for _, PartName in next, UseBodyParts do
												local Part = FFC((GameTitle == "Bad Business" and Character.Body or Character), PartName, true)
												if Part then
													local Cham = FFC(Objects.Chams, PartName) or (function()
														return library:Create("BoxHandleAdornment", {
															Name = PartName,
															AlwaysOnTop = true,
															ZIndex = 2,
															Parent = Objects.Chams
														})
													end)()

													Cham.Size = Part.Size
													Cham.Adornee = Part
													Cham.Transparency = library.flags[Team .. " Chams Transparency"]
													Cham.Color3 = ChamsColor

													if library.flags[Team .. " Chams Outline"] then
														Objects.ChamsOutlineVisible = true
														Objects.ChamsOutline.Parent = library.base
														Cham = FFC(Objects.ChamsOutline, PartName) or (function()
															return library:Create("BoxHandleAdornment", {
																Name = PartName,
																AlwaysOnTop = true,
																ZIndex = 1,
																Parent = Objects.ChamsOutline
															})
														end)()

														Cham.Size = Part.Size * 1.2
														Cham.Adornee = Part
														Cham.Transparency = library.flags[Team .. " Chams Transparency"]
														Cham.Color3 = ChamsOutlineColor
													else
														if Objects.ChamsOutlineVisible then
															Objects.InvisChamsOutline()
														end
													end
												else
													local Cham = FFC(Objects.Chams, PartName)
													if Cham then
														Cham.Visible = false
													end
													Cham = FFC(Objects.ChamsOutline, PartName)
													if Cham then
														Cham.Visible = true
													end
												end
											end
										end
									else
										if Objects.ChamsVisible then
											Objects.InvisChams()
											Objects.InvisChamsOutline()
										end
									end

									--ESP
									local Height = (Camera.CFrame - Camera.CFrame.p) * Vector3.new(0, (math.clamp(Size.Y, 1, 10) + 0.5) / 2, 0)
									Height = math.abs(WTSP(Camera, Pos.Position + Height).Y - WTSP(Camera, Pos.Position - Height).Y)
									--local ViewportSize = Camera.ViewportSize
									--local Size = ((ViewportSize.X + ViewportSize.Y) / Distance) * (1 - (Camera.FieldOfView / 200))
									Size = library.round(Vector2.new(Height / 2, Height))
									local Position = library.round(Vector2.new(ScreenPosition.X, ScreenPosition.Y) - (Size / 2))

									if library.flags[Team .. " Box Enabled"] then
										Objects.Box.Visible = true
										Objects.Box.Color = BoxColor
										Objects.Box.Size = Size
										Objects.Box.Position = Position
										Objects.Box.Transparency = Transparency

										Objects.BoxOutline.Visible = true
										Objects.BoxOutline.Size = Size + V222
										Objects.BoxOutline.Position = Position - V211
										Objects.BoxOutline.Transparency = Transparency

										Objects.BoxInline.Visible = true
										Objects.BoxInline.Size = Size - V222
										Objects.BoxInline.Position = Position + V211
										Objects.BoxInline.Transparency = Transparency
									else
										Objects.Box.Visible = false
										Objects.BoxOutline.Visible = false
										Objects.BoxInline.Visible = false
									end

									if library.flags[Team .. " Health Enabled"] then
										local MaxHealth = Data.MaxHealth
										local HealthPerc = Health / MaxHealth
										local Position = Position - HealthBarAddon
										local Size = Vector2.new(1, Size.Y)

										Objects.BarOutline.Visible = true
										Objects.BarOutline.Position = Position - V211
										Objects.BarOutline.Size = Size + V222
										Objects.BarOutline.Transparency = Transparency

										Objects.Bar.Visible = true
										Objects.Bar.Color = Color3.new(1 - HealthPerc, HealthPerc, 0.2)
										Objects.Bar.Position = Position + Vector2.new(0, Size.Y)
										Objects.Bar.Size = Vector2.new(1, -Size.Y * HealthPerc)
										Objects.Bar.Transparency = Transparency

										Objects.HealthText.Visible = HealthPerc < 0.99
										Objects.HealthText.Position = Objects.Bar.Position + Objects.Bar.Size - Vector2.new(0, 7)
										Objects.HealthText.Text = tostring(library.round(Health)) or ""
										Objects.HealthText.Transparency = Transparency
									else
										Objects.BarOutline.Visible = false
										Objects.Bar.Visible = false
										Objects.HealthText.Visible = false
									end

									if library.flags[Team .. " Info"] then
										Objects.NameText.Visible = true
										Objects.NameText.Text = GameTitle == "Blackhawk Rescue Mission" and (Player.ClassName == "Model" and (Player.Name:find("Infantry") and "Infantry" or "Civilian")) or Player.Name
										Objects.NameText.Position = Position + Vector2.new(Size.X / 2, -Objects.NameText.TextBounds.Y - 1)
										Objects.NameText.Color = TextColor
										Objects.NameText.Transparency = Transparency

										Objects.DistanceText.Visible = true
										Objects.DistanceText.Text = "[" .. library.round(Distance) .. "m]"
										Objects.DistanceText.Position = Position + Vector2.new(Size.X / 2, Size.Y + 2)
										Objects.DistanceText.Color = TextColor
										Objects.DistanceText.Transparency = Transparency
									else
										Objects.NameText.Visible = false
										Objects.DistanceText.Visible = false
									end

									if library.flags[Team .. " Look Enabled"] then
										HeadPosition = GetHitboxFromChar(Character, "Head")
										if HeadPosition then
											Objects.LookAt.Visible = true
											HeadPosition1 = WTVP(Camera, HeadPosition.Position)
											local To = WTVP(Camera, HeadPosition.Position + (HeadPosition.CFrame.LookVector * 8))

											Objects.LookAt.From = Vector2.new(HeadPosition1.X, HeadPosition1.Y)
											Objects.LookAt.To = Vector2.new(To.X, To.Y)
											Objects.LookAt.Color = LookColor
											Objects.LookAt.Transparency = Transparency
										else
											Objects.LookAt.Visible = false
										end
									else
										Objects.LookAt.Visible = false
									end

									if library.flags[Team .. " Direction Enabled"] then
										Objects.DirectionLine.Visible = true

										Position = Position + (Size / 2)
										local PositionOffset2d = V2Empty
										local Diff = (Pos.Position - Data.LastPosition)
										if Diff.Magnitude > 0.01 then
											PositionOffset2d = library.round(Vector2.new(WTSP(Camera, Pos.Position + (Diff.Unit * 4)).X, Position.Y) - Position)
										end

										Objects.DirectionLine.From = Position
										Objects.DirectionLine.To = Position + PositionOffset2d
										Objects.DirectionLine.Color = DirectionColor
										Objects.DirectionLine.Transparency = Transparency

										if Distance < 600 then
											Objects.DirectionDot.Visible = true
											Objects.DirectionDot.Position = Objects.DirectionLine.To - V233
											Objects.DirectionDot.Color = DirectionColor
											Objects.DirectionDot.Transparency = Transparency
										else
											Objects.DirectionDot.Visible = false
										end
									else
										Objects.DirectionLine.Visible = false
										Objects.DirectionDot.Visible = false
									end

									Data.LastPosition = Pos.Position
									continue
								end
								if library.flags[Team .. " OOV Arrows"] then
									Objects.OOVArrow.Visible = true
									Objects.OOVArrow.Color = Color or library.flags[Team .. Occluded .. "OOV Arrows Color"]

									local RelativePos = Camera.CFrame:Inverse() * Pos.Position
									local Middle = Camera.ViewportSize / 2
									local Degrees = math.deg(math.atan2(-RelativePos.Y, RelativePos.X)) * math.pi / 180
									local EndPos = Middle + (Vector2.new(math.cos(Degrees), math.sin(Degrees)) * library.flags[Team .. " Out Of View Scale"])

									Objects.OOVArrow.PointB = EndPos + (-(Middle - EndPos).Unit * 15)
									Objects.OOVArrow.PointA = EndPos
									Objects.OOVArrow.PointC = EndPos
									Objects.OOVArrow.Transparency = Transparency

									if not Objects.Visible then
										continue
									end
								end
							end
						end
					end
				end

				Objects.OOVArrow.Visible = false
				if Objects.Visible then
					Objects.Invis()
					Objects.InvisChams()
					Objects.InvisChamsOutline()
					Objects.InvisRadar()
				end
			end
		end)
	end}):AddList({flag = "Esp Enabled For", values = {"Enemies", "Teammates"}, multiselect = true}):AddBind({callback = function()
		library.options["Esp Enabled"]:SetState(not library.flags["Esp Enabled"])
	end})
	PlayerEspSection:AddSlider({text = "Max Distance", textpos = 2, flag = "Esp Max Distance", value = 10000, min = 0, max = 10000})
	PlayerEspSection:AddToggle({text = "Show Whitelisted Players", flag = "Esp Show Whitelisted"})

	--PlayerEspSection:AddDivider"Radar"
	--PlayerEspSection:AddToggle({text = "Enabled", flag = "Radar Enabled", callback = function(State)
	--	RadarWindow.Visible = State and library.flags["Esp Enabled"]
	--end})
	local VisualsWorld = VisualsColumn:AddSection"Lighting"
	VisualsWorld:AddToggle({text = "Clock Time"}):AddSlider({flag = "Clock Time Amount", min = 0, max = 24, float = 0.1, value = LightingSpoof.ClockTime})
	VisualsWorld:AddToggle({text = "Brightness"}):AddSlider({flag = "Brightness Amount", min = 0, max = 100, float = 0.1, value = LightingSpoof.Brightness})
	VisualsWorld:AddToggle({text = "Ambient", flag = "Ambient Lighting"}):AddColor({flag = "Outdoor Ambient", color = LightingSpoof.OutdoorAmbient}):AddColor({flag = "Indoor Ambient", color = LightingSpoof.Ambient})
	VisualsWorld:AddToggle({text = "Color Shift"}):AddColor({flag = "Color Shift Top", color = LightingSpoof.ColorShift_Top})

	local VisualsMiscSection = VisualsColumn:AddSection"Misc"

	VisualsMiscSection:AddToggle({text = "FOV Changer", callback = function(State)
		library.options["Dynamic Custom FOV"].main.Visible = State
	end}):AddSlider({flag = "FOV Amount", min = 0, max = 120})
	VisualsMiscSection:AddToggle({text = "Dynamic", flag = "Dynamic Custom FOV"})
	VisualsMiscSection:AddToggle({text = "Zoom", flag = "FOV Zoom Enabled"}):AddSlider({flag = "FOV Zoom Amount", min = 5, max = 50}):AddBind({flag = "FOV Zoom Key", mode = "hold"})

	VisualsMiscSection:AddDivider"Crosshair"
	VisualsMiscSection:AddToggle({text = "Enabled", flag = "Crosshair Enabled", callback = function(State)
		library.options["Crosshair T-Shape"].main.Visible = State
		library.options["Crosshair Size"].main.Visible = State
		library.options["Crosshair Gap"].main.Visible = State
		library.options["Crosshair Thickness"].main.Visible = State
		CrosshairTop.Visible = State and not library.flags["Crosshair T-Shape"]
		CrosshairLeft.Visible = State
		CrosshairRight.Visible = State
		CrosshairBottom.Visible = State
	end}):AddColor({callback = function(Color)
		CrosshairTop.Color = Color
		CrosshairLeft.Color = Color
		CrosshairRight.Color = Color
		CrosshairBottom.Color = Color
	end, trans = 1, calltrans = function(Transparency)
		CrosshairTop.Transparency = Transparency
		CrosshairLeft.Transparency = Transparency
		CrosshairRight.Transparency = Transparency
		CrosshairBottom.Transparency = Transparency
	end})
	VisualsMiscSection:AddToggle({text = "T-Shape", flag = "Crosshair T-Shape", callback = function(State)
		CrosshairTop.Visible = library.flags["Crosshair Enabled"] and not State
	end})
	VisualsMiscSection:AddSlider({text = "Size", textpos = 2, flag = "Crosshair Size", min = 1, max = 500, callback = function(Value)
		local Thickness = library.flags["Crosshair Thickness"]
		CrosshairTop.Size = Vector2.new(Thickness, -Value)
		CrosshairLeft.Size = Vector2.new(-Value, Thickness)
		CrosshairRight.Size = Vector2.new(Value, Thickness)
		CrosshairBottom.Size = Vector2.new(Thickness, Value)
	end})
	VisualsMiscSection:AddSlider({text = "Gap", textpos = 2, flag = "Crosshair Gap", min = 0, max = 20, float = 0.5})
	VisualsMiscSection:AddSlider({text = "Thickness", textpos = 2, flag = "Crosshair Thickness", min = 1, max = 20, float = 0.5, callback = function(Value)
		local Size = library.flags["Crosshair Size"]
		CrosshairTop.Size = Vector2.new(Value, -Size)
		CrosshairLeft.Size = Vector2.new(-Size, Value)
		CrosshairRight.Size = Vector2.new(Size, Value)
		CrosshairBottom.Size = Vector2.new(Value, Size)
	end})

	local PlayerEspEnemySection = VisualsColumn1:AddSection"Enemies"
	PlayerEspEnemySection:AddToggle({text = "Visible Only", flag = "Enemy Visible Only"})

	PlayerEspEnemySection:AddToggle({text = "Box", flag = "Enemy Box Enabled"}):AddColor({flag = "Enemy Occluded Box Color", color = Color3.fromRGB(245, 120, 65)}):AddColor({flag = "Enemy Box Color", color = Color3.fromRGB(240, 40, 50)})

	PlayerEspEnemySection:AddToggle({text = "Info", flag = "Enemy Info"}):AddColor({flag = "Enemy Occluded Info Color", color = Color3.fromRGB(255, 140, 30)}):AddColor({flag = "Enemy Info Color", color = Color3.fromRGB(240, 30, 40)})

	PlayerEspEnemySection:AddToggle({text = "Health", flag = "Enemy Health Enabled"})

	PlayerEspEnemySection:AddToggle({text = "Out Of View", flag = "Enemy OOV Arrows", callback = function(State)
		library.options["Enemy Out Of View Scale"].main.Visible = State
	end}):AddColor({flag = "Enemy Occluded OOV Arrows Color", color = Color3.fromRGB(255, 140, 30)}):AddColor({flag = "Enemy OOV Arrows Color", color = Color3.fromRGB(240, 30, 40)})
	PlayerEspEnemySection:AddSlider({text = "Scale", textpos = 2, flag = "Enemy Out Of View Scale", min = 100, max = 500})

	PlayerEspEnemySection:AddToggle({text = "Look Direction", flag = "Enemy Look Enabled"}):AddColor({flag = "Enemy Occluded Look Color", color = Color3.fromRGB(240, 120, 80)}):AddColor({flag = "Enemy Look Color", color = Color3.fromRGB(240, 60, 20)})

	--PlayerEspEnemySection:AddToggle({text = "Velocity", flag = "Enemy Direction Enabled"}):AddColor({flag = "Enemy Occluded Direction Color", color = Color3.fromRGB(240, 120, 80)}):AddColor({flag = "Enemy Direction Color", color = Color3.fromRGB(240, 60, 20)})

	PlayerEspEnemySection:AddToggle({text = "Chams", flag = "Enemy Chams Enabled"}):AddSlider({text = "Transparency", flag = "Enemy Chams Transparency", min = 0, max = 1, float = 0.1}):AddColor({flag = "Enemy Occluded Chams Color", color = Color3.fromRGB(245, 120, 65)}):AddColor({flag = "Enemy Chams Color", color = Color3.fromRGB(240, 40, 50)})
	PlayerEspEnemySection:AddToggle({text = "Outline", flag = "Enemy Chams Outline"}):AddColor({flag = "Enemy Occluded Chams Outline Color", color = Color3.fromRGB(245, 120, 65)}):AddColor({flag = "Enemy Chams Outline Color", color = Color3.fromRGB(240, 40, 50)})

	local PlayerEspTeamSection = VisualsColumn1:AddSection"Teammates"
	PlayerEspTeamSection:AddToggle({text = "Visible Only", flag = "Team Visible Only"})

	PlayerEspTeamSection:AddToggle({text = "Box", flag = "Team Box Enabled"}):AddColor({flag = "Team Occluded Box Color", color = Color3.fromRGB(20, 50, 255)}):AddColor({flag = "Team Box Color", color = Color3.fromRGB(40, 255, 180)})

	PlayerEspTeamSection:AddToggle({text = "Info", flag = "Team Info"}):AddColor({flag = "Team Occluded Info Color", color = Color3.fromRGB(20, 120, 255)}):AddColor({flag = "Team Info Color", color = Color3.fromRGB(40, 240, 130)})

	PlayerEspTeamSection:AddToggle({text = "Health", flag = "Team Health Enabled"})

	PlayerEspTeamSection:AddToggle({text = "Out Of View", flag = "Team OOV Arrows", callback = function(State)
		library.options["Team Out Of View Scale"].main.Visible = State
	end}):AddColor({flag = "Team Occluded OOV Arrows Color", color = Color3.fromRGB(20, 120, 255)}):AddColor({flag = "Team OOV Arrows Color", color = Color3.fromRGB(40, 240, 130)})
	PlayerEspTeamSection:AddSlider({text = "Scale", textpos = 2, flag = "Team Out Of View Scale", min = 100, max = 500})

	PlayerEspTeamSection:AddToggle({text = "Look Direction", flag = "Team Look Enabled"}):AddColor({flag = "Team Occluded Look Color", color = Color3.fromRGB(40, 80, 230)}):AddColor({flag = "Team Look Color", color = Color3.fromRGB(40, 250, 100)})

	--PlayerEspTeamSection:AddToggle({text = "Velocity", flag = "Team Direction Enabled"}):AddColor({flag = "Team Occluded Direction Color", color = Color3.fromRGB(240, 120, 80)}):AddColor({flag = "Team Direction Color", color = Color3.fromRGB(240, 60, 20)})

	PlayerEspTeamSection:AddToggle({text = "Chams", flag = "Team Chams Enabled"}):AddSlider({text = "Transparency", flag = "Team Chams Transparency", min = 0, max = 1, float = 0.1}):AddColor({flag = "Team Occluded Chams Color", color = Color3.fromRGB(20, 50, 255)}):AddColor({flag = "Team Chams Color", color = Color3.fromRGB(40, 255, 180)})
	PlayerEspTeamSection:AddToggle({text = "Outline", flag = "Team Chams Outline"}):AddColor({flag = "Team Occluded Chams Outline Color", color = Color3.fromRGB(80, 100, 255)}):AddColor({flag = "Team Chams Outline Color", color = Color3.fromRGB(80, 255, 200)})

	--Misc stuff
	local MiscTab = library:AddTab"Misc"
	local MiscColumn = MiscTab:AddColumn()
	local MiscColumn1 = MiscTab:AddColumn()
	local MiscMain = MiscColumn:AddSection"Main"
	MiscMain:AddButton({text = "Copy Discord invite", callback = function() setclipboard("https://discord.gg/pBRqP4xT9P") end})
	if syn then
		MiscMain:AddSlider({text = "Set FPS Cap", min = 60, max = 300, callback = function(Value) setfpscap(Value) end})
	end
	local Lagging
	MiscMain:AddToggle({text = "Lag Switch", callback = function()
		Lagging = false
		Settings.Network.IncomingReplicationLag = 0
	end}):AddSlider({text = "Timeout", flag = "Lag Switch Timeout", min = 1, max = 10, float = 0.1, suffix = "s"}):AddBind({callback = function()
		if library.flags["Lag Switch"] then
			Lagging = not Lagging
			Settings.Network.IncomingReplicationLag = Lagging and 1000 or 0
			if Lagging then
				local LagStart = tick()
				while Lagging do
					wait(1)
					if tick() - LagStart >= library.flags["Lag Switch Timeout"] then
						library.options["Lag Switch"].callback()
					end
				end
			end
		end
	end})

	local PlayerList = MiscColumn1:AddSection"Player List"
	PlayerList:AddList({flag = "Player List", textpos = 2, skipflag = true, max = 10, values = (function() local t = {} for _, Player in next, PlayerServ:GetPlayers() do if Player ~= Client then table.insert(t, Player.Name) end end return t end)(), callback = function(Value)
		local Player = Players[FFC(PlayerServ, Value)]
		library.options["Set Player Priority"]:SetState(Player and Player.Priority, true)
		library.options["Set Player Whitelist"]:SetState(Player and Player.Whitelist, true)
	end})
	PlayerList:AddToggle({text = "Priority", skipflag = true, style = 2, flag = "Set Player Priority", callback = function(State)
		local Player = Players[FFC(PlayerServ, library.flags["Player List"])]
		if Player then
			Player.Priority = State
			if State then
				library.options["Set Player Whitelist"]:SetState(false)
			end
		end
	end}):AddColor({flag = "Player Priority Color", color = Color3.fromRGB(255, 255, 0)})
	PlayerList:AddToggle({text = "Whitelist", skipflag = true, style = 2, flag = "Set Player Whitelist", callback = function(State)
		local Player = Players[FFC(PlayerServ, library.flags["Player List"])]
		if Player then
			Player.Whitelist = State
			if State then
				library.options["Set Player Priority"]:SetState(false)
			end
		end
	end}):AddColor({flag = "Player Whitelist Color", color = Color3.fromRGB(0, 255, 255)})

	--[[
	local XPos, YPos, ZPos = 0, 0, 0
	local FreecamPos = Camera.CFrame.Position
	local CameraCF = Camera.CFrame
	local CameraSubject, CameraType = Camera.CameraSubject, Camera.CameraType

	local MiscFreecam = MiscColumn1:AddSection"Freecam"
	MiscFreecam:AddToggle({
	text = "Enabled", flag = "Freecam Enabled", tip = "Note: this will stop your character from moving"}):AddSlider({
	text = "Speed", flag = "Freecam Speed", min = 1, max = 20}):AddBind({
	flag = "Freecam Key", mode = "hold", callback = function(Ended)
		if library.flags["Freecam Enabled"] then
			if Ended then
				Camera.CFrame = CFrame.new(CameraCF.Position, CameraCF.LookVector)
				Camera.CameraType = CameraType
				Camera.CameraSubject = CameraSubject
			else
				--Camera.CameraType = "Scriptable"
				--Camera.CameraSubject = nil
				FreecamPos = CameraCF.Position + (Vector3.new(XPos, YPos, ZPos) * library.flags["Freecam Speed"])
				Camera.CFrame = CFrame.new(FreecamPos, CameraCF.LookVector)
			end
		end
	end})

	library:AddConnection(inputService.InputBegan, function(Input)
		if Input.KeyCode.Name == "W" then
			ZPos = ZPos + 1
		elseif Input.KeyCode.Name == "S" then
			ZPos = ZPos - 1
		elseif Input.KeyCode.Name == "D" then
			XPos = XPos + 1
		elseif Input.KeyCode.Name == "A" then
			XPos = XPos - 1
		elseif Input.KeyCode.Name == "Space" then
			YPos = YPos + 1
		elseif Input.KeyCode.Name == "LeftShift" then
			YPos = YPos - 1
		end
	end)
	library:AddConnection(inputService.InputBegan, function(Input)
		if Input.KeyCode.Name == "W" then
			ZPos = ZPos - 1
		elseif Input.KeyCode.Name == "S" then
			ZPos = ZPos + 1
		elseif Input.KeyCode.Name == "D" then
			XPos = XPos - 1
		elseif Input.KeyCode.Name == "A" then
			XPos = XPos + 1
		elseif Input.KeyCode.Name == "Space" then
			YPos = YPos - 1
		elseif Input.KeyCode.Name == "LeftShift" then
			YPos = YPos + 1
		end
	end)
	--]]


	--Hooks
	local OldCallingScript
	OldCallingScript = hookfunction(getcallingscript, function()
		return OldCallingScript() or {}
	end)

	local Old_new
	Old_new = hookmetamethod(game, "__newindex", function(t, i, v)
		if checkcaller() or not library then return Old_new(t, i, v) end

		if t == Camera then
			if i == "CFrame" then
				--CameraCF = v
				if library.flags["Freecam Enabled"] and library.flags["Freecam Key"] then
					--v = CFrame.new(FreecamPos, CameraCF.LookVector)
				else
					if library.flags["Aimbot Mode"] == "Rage" then
						if library.Aimbot.Position3d then
							v = CFrame.new(v.p, library.Aimbot.Position3d)
						end
					end
				end
			elseif i == "CameraSubject" then
				--CameraSubject = v
				--print("setting subject")
				--return not (library.flags["Freecam Enabled"] and library.flags["Freecam Key"]) and CameraSubject or nil
			elseif i == "CameraType" then
				--CameraType = v
				--print("setting type")
				--return (library.flags["Freecam Enabled"] and library.flags["Freecam Key"]) and "Scriptable" or CameraType
			end
		end

		if GameTitle == "Bad Business" then
			if i == "Velocity" then
				if library.flags["Jump Multiplier"] ~= 1 then
					if OldCallingScript().Name == "ControlScript" then
						v = Vector3.new(v.X, v.Y * library.flags[GameTitle .. " Jump Multiplier"], v.Z)
					end
				end
				if library.flags["Speed Multiplier"] ~= 1 then
					if t.Name == "Root" then
						local X,Y,Z = v.X * library.flags[GameTitle .. " Speed Multiplier"], v.Y, v.Z * library.flags[GameTitle .. " Speed Multiplier"]
						v = Vector3.new(X, Y, Z)
					end
				end
			end
		elseif GameTitle == "Ace Of Spadez" then
			if library.flags[GameTitle .. " No Recoil"] then
				if t == Camera and i == "CFrame" then
					if OldCallingScript().Name == "WeaponSystem" then
						return
					end
				end
			end
		elseif GameTitle == "Counter Blox" then
			if i == "WalkSpeed" then
				if library.flags[GameTitle .. " Bhop"] and not inputService:GetFocusedTextBox() then
					if inputService:IsKeyDown(Enum.KeyCode.Space) then
						v = library.flags[GameTitle .. " Bhop Speed"]
					end
				end
			end
		end

		if t == Lighting then
			if i == "ClockTime" then
				LightingSpoof[i] = v
				v = library.flags["ClockTime"] and library.flags["Clock Time Amount"] or v
			elseif i == "Brightness" then
				LightingSpoof[i] = v
				v = library.flags["Brightness"] and library.flags["Brightness Amount"] or v
			elseif i == "Ambient" or i == "OutdoorAmbient" then
				LightingSpoof[i] = v
				v = library.flags["Ambient Lighting"] and (i == "Ambient" and library.flags["Indoor Ambient"] or library.flags["Outdoor Ambient"]) or v
			elseif i == "ColorShift_Top" then
				LightingSpoof[i] = v
				v = library.flags["Color Shift"] and library.flags["Color Shift Top"] or v
			end
		elseif t == Camera then
			if i == "FieldOfView" then
				CameraSpoof[i] = v
				v = (library.flags["FOV Zoom Enabled"] and library.flags["FOV Zoom Key"] and (50 - library.flags["FOV Zoom Amount"])) or library.flags["FOV Changer"] and (library.flags["Dynamic Custom FOV"] and (CameraSpoof.FieldOfView + library.flags["FOV Amount"]) or library.flags["FOV Amount"]) or v
			end
		end

		return Old_new(t, i, v)
	end)

	local Old_index
	Old_index = hookmetamethod(game, "__index", function(t, i)
		if checkcaller() or not library then return Old_index(t, i) end

		if t == Camera then
			if i == "CFrame" then
				if library.flags["Freecam Enabled"] and library.flags["Freecam Key"] then
					--return CameraCF
				end
				if library.Aimbot.Position3d then
					if library.flags["Aimbot Mode"] == "Silent" then
						if GameTitle == "Bad Business" then
							if OldCallingScript().Name == "ItemControlScript" then
								local OldCF = Old_index(t, i)
								return CFrame.new(OldCF.Position, library.Aimbot.Position3d)
							end
						end
					elseif library.flags["Aimbot Mode"] == "Rage" then
						return CFrame.new(Old_index(t, i).Position, library.Aimbot.Position3d)
					end
				end
			elseif i == "CameraSubject" then
				--return CameraSubject
			elseif i == "CameraType" then
				--return CameraType
			end
		end

		if t == Lighting then
			if i == "ClockTime" or i == "Brightness" or i == "Ambient" or i == "OutdoorAmbient" or i == "ColorShift_Top" then
				return LightingSpoof[i]
			end
		elseif t == Camera then
			if i == "FieldOfView" then
				return CameraSpoof[i]
			end
		end

		return Old_index(t, i)
	end)

	local Old_call
	Old_call= hookmetamethod(game, "__namecall", function(self, ...)
		if checkcaller() or not library then return Old_call(self, ...) end

		local Args = {...}
		local Method = getnamecallmethod()

		if Method == "FindPartOnRayWithWhitelist" then
			if GameTitle == "Bad Business" then
				if Args[2][1] and Args[2][2] and Args[2][1].Name == "Geometry" and Args[2][2].Name == "Terrain" then
					if library.flags[GameTitle .. " Wallbang"] then
						Args[2][1] = nil
						Args[2][2] = nil
					end
				end
			elseif GameTitle == "Ace Of Spadez" then
				if OldCallingScript().Name == "WeaponSystem" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * library.flags["Aimbot Max Distance"])
					end
					if library.flags[GameTitle .. " Wallbang"] then
						Args[2][1] = nil
					else
						Args[2][1] = workspace.Game.Map
					end
				end
			elseif GameTitle == "Zombie Attack" then
				if OldCallingScript().Name == "GunController" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * 1000)
					end
				end
			end
		elseif Method == "FindPartOnRayWithIgnoreList" then
			if GameTitle == "Arsenal" then
				if library.flags[GameTitle .. " Wallbang"] and Args[2][1].Name == "Clips" then
					local n = #Args[2]
					Args[2][n + 1] = workspace.Map
				end
				if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
					Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).Unit * library.flags["Aimbot Max Distance"])
				end
			elseif GameTitle == "Unit: Classified" then
				if #Args[2] > 15 then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * library.flags["Aimbot Max Distance"])
					end
					if library.flags[GameTitle .. " Wallbang"]  then
						local n = #Args[2]
						Args[2][n + 1] = workspace.Map
						Args[2][n + 2] = workspace.Terrain
					end
				end
			elseif GameTitle == "MURDER" then
				if tostring(Args[2][3]) == "Debris" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * library.flags["Aimbot Max Distance"])
					end
					if library.flags[GameTitle .. " Wallbang"]  then
						local n = #Args[2]
						Args[2][n + 1] = workspace.Map
					end
				end
			elseif GameTitle == "KAT" then
				if OldCallingScript().Name == "KnifeClient" or OldCallingScript().Name == "RevolverClient" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * library.flags["Aimbot Max Distance"])
					end
				end
			elseif GameTitle == "MMC Zombies Project" then
				if OldCallingScript().Name == "client_main" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * library.flags["Aimbot Max Distance"])
					end
					if library.flags[GameTitle .. " Wallbang"] then
						setnamecallmethod("FindPartOnRayWithWhitelist")
						Args[2] = {
							workspace.map.enemies,
						}
					end
				end
			elseif GameTitle == "Project Lazarus" then
				if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
					Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * library.flags["Aimbot Max Distance"])
				end
				if library.flags[GameTitle .. " Wallbang"] then
					local n = #Args[2]
					Args[2][n + 1] = workspace.Map
				end
			elseif GameTitle == "Zombie Rush" then
				if OldCallingScript().Name == "GunController" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * 1000)
					end
					if library.flags[GameTitle .. " Wallbang"] then
						local n = #Args[2]
						Args[2][n + 1] = workspace["Map Storage"]
					end
				end
			elseif GameTitle == "Resurrection" then
				if OldCallingScript().Name == "Client" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * 1000)
					end
					if library.flags[GameTitle .. " Wallbang"] then
						local n = #Args[2]
						Args[2][n + 1] = workspace.Map
						Args[2][n + 2] = workspace.Terrain
					end
				end
			elseif GameTitle == "Blackhawk Rescue Mission" then
				if OldCallingScript().Name == "InputHandler" then
					if library.flags[GameTitle .. " Wallbang"] then
						local n = #Args[2]
						Args[2][n + 1] = workspace.Terrain
						Args[2][n + 2] = workspace.Custom["0"]
					end
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).Unit * library.flags["Aimbot Max Distance"])
					end
				end
			elseif GameTitle == "Shoot Out" then
				if OldCallingScript().Name == "Replication" then
					if library.flags[GameTitle .. " Wallbang"] then
						local n = #Args[2]
						Args[2][n + 1] = workspace.Map
					end
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).Unit * library.flags["Aimbot Max Distance"])
					end
				end
			elseif GameTitle == "Weaponry" then
				if OldCallingScript().Name == "Client_Major_Framework" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).Unit * library.flags["Aimbot Max Distance"])
					end
				end
			elseif GameTitle == "Counter Blox" then
				if #Args[2] > 10 then
					if library.flags[GameTitle .. " No Spread"] then
						local Char = Players[Client].Character
						if Char then
							Args[1] = Ray.new(Vector3.new(Char.HumanoidRootPart.Position.X, Char.Head.Position.Y, Char.HumanoidRootPart.Position.Z), Camera.CFrame.LookVector * 1000)
						end
					end
					if library.flags[GameTitle .. " Wallbang"] then
						Args[2][#Args[2] + 1] = workspace.Map
					end
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						local Char = Players[Client].Character
						if Char then
							local Origin = Vector3.new(Char.HumanoidRootPart.Position.X, Char.Head.Position.Y, Char.HumanoidRootPart.Position.Z)
							Args[1] = Ray.new(Origin, (library.Aimbot.Position3d - Origin).Unit * 1000)
						end
					end
				end
			elseif GameTitle == "Death Zone" then
				if OldCallingScript().Name == "GunScript" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).Unit * library.flags["Aimbot Max Distance"])
					end
				end
			end

		elseif Method == "FireServer" then
			if GameTitle == "Arsenal" then
				if self.Name == "CreateProjectile" or self.Name == "ReplicateProjectile" then
					local t = self.Name == "ReplicateProjectile" and Args[1] or Args
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						t[3] = library.Aimbot.Position3d
						t[4] = CFrame.new(library.Aimbot.Position3d) + Vector3.new(0, 0.5, 0)
						t[10] = library.Aimbot.Position3d + Vector3.new(0, 0.5, 0)
					end
				end
			elseif GameTitle == "Zombie Attack" then
				if library.flags[GameTitle .. " Always Headshot"] and FFCoC(Args["Hit"].Parent, "Humanoid") then
					Args["Hit"] = Args["Hit"].Parent.Head
				end
			elseif GameTitle == "Counter Blox" then
				if self.Name == "ControlTurn" and library.flags[GameTitle .. " Anti-Aim"] then
					Args[1] = library.flags[GameTitle .. " Pitch"]
					--elseif string.len(self.Name) > 35 then
					--	if library.flags[GameTitle .. " Unlock Skins"] and not eF then
					--		eF = true
					--		for V, v in next, e4 do
					--			local eQ
					--			for eC, eD in next, Args[1] do
					--				if v[1] == eD[1] then
					--					eQ = true
					--				end
					--			end
					--			if not eQ then
					--				local n = #Args[1]
					--				Args[1][n + 1] = v
					--			end
					--		end
					--	end
					--	return
				elseif self.Name == "HitPart" and (library.flags[GameTitle .. " Hitsound"] or library.flags[GameTitle .. " Bullet Tracers"]) then
					spawn(function()
						if library.flags[GameTitle .. " Hitsound"] then
							if Args[1] and FFCoC(Args[1].Parent, "Humanoid") then
								local Target = FFC(game.Players, Args[1].Parent.Name)
								if Target and Target.Team ~= Client.Team then
									local Sounds = library.options[GameTitle .. " Hitsounds"].values
									local Sound = library.flags[GameTitle .. " Hitsounds"]
									library:Create("Sound", {
										PlayOnRemove = true,
										Volume = library.flags[GameTitle .. " Hitsound Volume"],
										SoundId = "rbxassetid://" .. (typeof(Sounds[Sound]) == "function" and Sounds[Sound]() or Sounds[Sound]),
										Parent = workspace
									}):Destroy()
								end
							end
						end
						if library.flags[GameTitle .. " Bullet Tracers"] then
							local Char = Client.Character
							local HumPart = FFC(Char, "HumanoidRootPart")
							local Flash = FFC(Camera, "Flash", true)
							if HumPart and Flash then
								local d1 = library:Create("Part", {Anchored = true, Parent = workspace})
								local eV = library:Create("Attachment", {WorldPosition = Flash.Position, Parent = d1})
								local eW = library:Create("Attachment", {WorldPosition = Args[2], Parent = d1})
								library:Create("Beam", {
									Color = ColorSequence.new(library.flags[GameTitle .. " Bullet Tracer Color"]),
									LightEmission = 1,
									LightInfluence = 0,
									Texture = "rbxassetid://967852047",
									Transparency = NumberSequence.new(0.6),
									TextureLength = 0.1,
									TextureSpeed = 1,
									Attachment0 = eV,
									Attachment1 = eW,
									Segments = 1,
									FaceCamera = true,
									Width0 = 0.15,
									Width1 = 0.15,
									Parent = d1
								})
								library:Create("Beam", {
									Color = ColorSequence.new(library.flags[GameTitle .. " Bullet Tracer Color"]),
									LightEmission = 1,
									LightInfluence = 0,
									Texture = "rbxassetid://967852047",
									Transparency = NumberSequence.new(0.6),
									TextureLength = 0.1,
									TextureSpeed = 1,
									Attachment0 = eV,
									Attachment1 = eW,
									Segments = 1,
									FaceCamera = true,
									Width0 = 0.2,
									Width1 = 0.2,
									Parent = d1
								})
								game:GetService"Debris":AddItem(d1, library.flags[GameTitle .. " Lifetime"])
							end
						end
					end)
				end
			elseif GameTitle == "Death Zone" then
				if self.Name == "Executioner" then
					return wait(9e9)
				end
			end

		elseif Method == "InvokeServer" then

		elseif Method == "SetPrimaryPartCFrame" then
			if GameTitle == "Counter Blox" then
				if self.Name == "Arms" then
					if library.flags[GameTitle .. " Viewmodel Changer"] then
						if library.flags[GameTitle .. " Flip Z"] then
							Args[1] = Args[1] * CFrame.new(1, 1, 1, 0, 0, 1, 0)
						end
						if library.flags[GameTitle .. " Flip Y"] then
							Args[1] = Args[1] * CFrame.new(1, 1, 1, 0.5, 0, 0, 0)
						end
						local X = library.flags[GameTitle .. " X Offset"] * 120 / 500
						local Y = library.flags[GameTitle .. " Y Offset"] * 120 / 500
						local dl = library.flags[GameTitle .. " Z Offset"] * 120 / 500
						Args[1] = Args[1] * CFrame.new(X, Y, library.flags[GameTitle .. " Flip Y"] and dl * 2 or dl)
					end
				end
			end
		end

		return Old_call(self, unpack(Args))
	end)

	--Games
	local Loaded, LoadError = true
	library.flagprefix = GameTitle

	Loaded, LoadError = pcall(function()

		if GameTitle == "Bad Business" then

			local BadBusinessTab = library:AddTab"Bad Business"
			local BadBusinessColumn = BadBusinessTab:AddColumn()
			local BadBusinessColumn1 = BadBusinessTab:AddColumn()

			local BadBusinessMain = BadBusinessColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			BadBusinessMain:AddToggle({text = "Wallbang"})

			local BadBusinessMisc = BadBusinessColumn:AddSection"Misc"
			BadBusinessMisc:AddSlider({text = "Speed Multiplier", min = 1, max = 3, float = 0.1})
			BadBusinessMisc:AddSlider({text = "Jump Multiplier", min = 1, max = 5, float = 0.1})
			--BadBusinessMain:AddToggle({text = "Custom Pitch"}):AddSlider({text = "Pitch", min = -1.5, max = 1.5, float = 0.1})

			local WeaponMods = BadBusinessColumn1:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "No Recoil"})
			WeaponMods:AddToggle({text = "No Bullet Drop"})

			local OldRay
			repeat wait(1)
				for i, v in next, getreg(true) do
					if typeof(v) == "table" then
						if rawget(v, "GetCharacter") then
							NameRequest = debug.getupvalue(v.GetPlayerFromCharacter, 1)
						elseif rawget(v, "GetPlayerTeam") then
							TeamRequest = v.GetPlayerTeam
						elseif rawget(v, "CastGeometryAndEnemies") then
							OldRay = v.CastGeometryAndEnemies
						end
					end
				end
			until NameRequest and TeamRequest and OldRay

			for i,v in next, getgc(true) do
				if typeof(v) == "table" and rawget(v, "Fire") and rawget(v, "Update") then
					local Fire = v.Fire
					v.Fire = function(...)
						if library then
							if not library.flags[GameTitle .. " No Recoil"] then
								Fire(...)
							end
						else
							Fire(...)
						end
					end
					local Update = v.Update
					v.Update = function(...)
						if library and library.flags[GameTitle .. " No Recoil"] then
							return Vector2.new(0, 0)
						else
							return Update(...)
						end
					end
				end
			end

			local RayHook
			RayHook = hookfunction(OldRay, function(...)
				if not library then return RayHook(...) end
				local Args = {...}

				if Args[5] then
					if library.flags[GameTitle .. " No Bullet Drop"] then
						Args[5].Gravity = 0
					end
				end

				return RayHook(...)
			end)

		elseif GameTitle == "Phantom Forces" then

			--local PFTab = library:AddTab"Phantom Forces"
			--library.options["Aimbot Mode"]:AddValue"Silent"
			local client = {}

			repeat wait(1)
				for k, v in next, getgc(true) do
					if type(v) == "table" and rawget(v, "removecharacterhash") then
						NameRequest = getupvalue(v.removecharacterhash, 3)
					end
					if type(v) == "function" then
						if getinfo(v).name == "bulletcheck" then
							client.bulletcheck = v
						end
						if getinfo(v).name == "trajectory" then
							client.traj = v
						end
						for k1, v1 in next, getupvalues(v) do
							if type(v1) == "table" then
								if rawget(v1, "send") then
									client.net = v1
								elseif rawget(v1, "gammo") then
									client.logic = v1
								elseif rawget(v1, "loadknife") then
									client.char = v1
								elseif rawget(v1, "basecframe") then
									client.cam = v1
								elseif rawget(v1, "votestep") then
									client.hud = v1
									HealthRequest = client.hud
								elseif rawget(v1, "getbodyparts") then
									client.repl = v1
								elseif rawget(v1, "checkkillzone") then
									client.roundsystem = v1
								end
							end
						end
					elseif type(v) == "table" then
						if rawget(v, "deploy") then
							client.menu = v
						elseif rawget(v, "new") and rawget(v, "step") then
							client.particle = v
						end
					end
				end
			until NameRequest and HealthRequest and client.logic
			ClientCharRequest = client

			local ReplacedFuncs = {}

			library:AddConnection(inputService.InputBegan, function(input)
				if input.UserInputType.Name == "MouseButton1" or input.UserInputType.Name == "MouseButton2" then
					if client.logic.currentgun then
						if client.logic.currentgun.shoot then
							local func = client.logic.currentgun.shoot
							if not ReplacedFuncs[func] then
								client.logic.currentgun.shoot = function(self, ...)
									if library and not library.open then
										func(self, ...)
									end
								end
								ReplacedFuncs[func] = true
							end
						end
						if client.logic.currentgun.setaim then
							local func = client.logic.currentgun.setaim
							if not ReplacedFuncs[func] then
								client.logic.currentgun.setaim = function(self, ...)
									if library and not library.open then
										func(self, ...)
									end
								end
								ReplacedFuncs[func] = true
							end
						end
					end
				end
			end)

			--Meta.__namecall = newcclosure(function(self, ...)
			--	if checkcaller() then return Old_call(self, ...) end
			--	local Args = {...}
			--	local Method = getnamecallmethod()
			--	if Method:find("Ray") and Method:lower():find("list") then
			--		if library.flags["Wallbang"] then
			--			local n = #Args[2]
			--			Args[2][n + 1] = workspace.Map
			--		end
			--		if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
			--			--Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).Unit * library.flags["Aimbot Max Distance"])
			--		end
			--	end
			--	return Old_call(self, unpack(Args))
			--end)

		elseif GameTitle == "Q-Clash" then

			--[[
			local SetHealth
			repeat wait(1)
				for i,v in next, getgc(true) do
					if type(v) == "table" and rawget(v, "SetHealth") then

						SetHealth = v.SetHealth

						break
					end
				end
			until SetHealth

			local Health = {}
			HealthRequest = function(Char)
				if Health[Char] then
					return Health[Char].Health, Health[Char].MaxHealth
				end
			end

			local o
			o = hookfunction(SetHealth, function(a, b, c)

				local Character = FFA(a.uiElements, "Model")
				Character = Character and FFCoC(Character, "Humanoid")
				if Character then
					if not Health[Character] then
						Health[Character] = {}
					end

					Health[Character].Health = math.ceil(b + c)
					Health[Character].MaxHealth = a.maxHealth
				end

				return o(a, b, c)
			end)
			--]]

		elseif GameTitle == "Arsenal" then


			local ArsenalTab = library:AddTab"Arsenal":AddColumn()
			local ArsenalMain = ArsenalTab:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			ArsenalMain:AddToggle({text = "Wallbang"})
			--ArsenalWindow:AddToggle({text = "No Recoil"})
			ArsenalMain:AddToggle({text = "Inf Ammo"})
			ArsenalMain:AddToggle({text = "Inf Jump"})
			VisualsMiscSection:AddColor({text = "Golden Weapon Color"})

			for _,Func in next, getgc() do
				if typeof(Func) == "function" then
					local Info = debug.getinfo(Func)
					if Info.name == "firebullet" then
						local o
						o = hookfunction(Func, function(...)
							if library and library.flags[GameTitle .. " Inf Ammo"] then
								setupvalue(o, 5, 999)
							end
							return o(...)
						end)
					end
				end
			end

			local Jumping
			local function InfJump()
				while library and Jumping do
					wait()
					local Char = Players[Client].Character
					if Char then
						Char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end

			library:AddConnection(inputService.InputBegan, function(Input)
				if library.flags[GameTitle .. " Inf Jump"] and not inputService:GetFocusedTextBox() then
					if Input.KeyCode == Enum.KeyCode.Space then
						Jumping = true
						InfJump()
					end
				end
			end)

			library:AddConnection(inputService.InputEnded, function(Input)
				if Input.KeyCode == Enum.KeyCode.Space then
					Jumping = false
				end
			end)

		elseif GameTitle == "Unit: Classified" then

			local UnitClient = getsenv(Client:WaitForChild"PlayerGui":WaitForChild"GUI":WaitForChild"Client")
			local Shake = UnitClient.ShakeCam

			local UnitTab = library:AddTab"Unit: Classified"
			local UnitColumn = UnitTab:AddColumn()
			--local UnitColumn1 = UnitTab:AddColumn()

			local UnitMain = UnitColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			UnitMain:AddToggle({text = "Wallbang"})

			--local WeaponMods = UnitColumn1:AddSection"Weapon Mods"
			UnitMain:AddToggle({text = "No Recoil", callback = function(State)
				UnitClient.ShakeCam = State and function() end or Shake
			end})
			UnitMain:AddToggle({text = "Inf Ammo", callback = function(State)
				if State then
					while library and library.flags[GameTitle .. " Inf Ammo"] and wait(1) do
						UnitClient.refillammo(math.huge)
					end
				end
			end})

		elseif GameTitle == "Counter Blox" then

			local CBTab = library:AddTab"Counter Blox"
			local MainColumn = CBTab:AddColumn()
			local MainColumn1 = CBTab:AddColumn()
			local e1 = MainColumn:AddSection"Rage"
			local e2 = tick()
			--local e4 = game:HttpGet("https://uwuware.cool/scripts/getfile.php?ID=rrkbB7GagR8Vbg4byAdJvw9HouiWOG9I", true)

			local CBClient = {}
			for i,v in next, getgc() do
				if typeof(v) == "function" then
					local info = debug.getinfo(v)
					if info.name == "resetaccuracy" then
						CBClient.resetaccuracy = v
					elseif info.name == "firebullet" then
						CBClient.firebullet = v
					end
				end
			end

			local function GetDamage(e7, e8, e9)
				local ClientChar = Players[Client].Character
				if ClientChar then
					--local eb
					local Gun = FFC(RepStorage.Weapons, ClientChar.EquippedTool.Value)
					if Gun then
						local ec = eb.Penetration.Value * 0.01
						local ed = eb.Range.Value
						local eg = ClientChar.HumanoidRootPart.Position
						local ej = 0
						local ek = 0
						local el, em, en
						local eo = 1
						local ep = 1
					end
				end
				local Ignores = {
					Camera,
					ClientChar,
					workspace.Debris,
					workspace.Ray_Ignore,
					workspace.Map:WaitForChild("Clips"),
					workspace.Map:WaitForChild("SpawnPoints")
				}
				for u, ea in next, e7.Character:GetDescendants() do
					if ea.Name ~= e8 then
						Ignores[#Ignores + 1] = ea
					end
				end
				
				repeat
					local eh = CFrame.new(Vector3.new(eg.X, ClientChar.Head.Position.Y, eg.Z), library.Aimbot.Position3d).LookVector.unit * ed * 0.0694
					el, em, en = workspace:FindPartOnRayWithIgnoreList(Ray.new(Vector3.new(eg.X, ClientChar.Head.Position.Y, eg.Z), eh), Ignores)
					if el and el.Parent then
						eo = 1
						if el.Material == Enum.Material.DiamondPlate then
							eo = 3
						elseif el.Material == Enum.Material.CorrodedMetal or el.Material == Enum.Material.Metal or el.Material == Enum.Material.Concrete or el.Material == Enum.Material.Brick then
							eo = 2
						elseif el.Name == "Grate" or el.Material == Enum.Material.Wood or el.Material == Enum.Material.WoodPlanks or el and el.Parent and FFCoC(el.Parent, "Humanoid") then
							eo = 0.1
						elseif el.Transparency == 1 or el.CanCollide == false or el.Name == "Glass" or el.Name == "Cardboard" or el:IsDescendantOf(workspace.Ray_Ignore) or el:IsDescendantOf(workspace.Debris) or el and el.Parent and el.Parent.Name == "Hitboxes" then
							eo = 0
						elseif el.Name == "nowallbang" then
							eo = 100
						elseif FFC(el, "PartModifier") then
							eo = el.PartModifier.Value
						end
						local eq, er = workspace:FindPartOnRayWithWhitelist(Ray.new(em + eh * 1, eh * -2), {el})
						local es = (er - em).Magnitude
						local es = es * eo
						ek = math.min(ec, ek + es)
						ep = 1 - ek / ec
						if eo > 0 then
							ej = ej + 1
						end
						if el and el.Parent and el.Parent.Name == "Hitboxes" or el and el.Parent and el.Parent.Parent and FFCoC(el.Parent.Parent, "Humanoid") and (1 > el.Transparency or el.Name == "HeadHB") and el.Parent:IsA("Model") then
							Ignores[#Ignores] = el.Parent
						else
							Ignores[#Ignores] = el
						end
					end
				until el == nil or el.Parent == e7.Character or ek >= ec or ep <= 0 or el.Name == "lastbacktrack" or el.Name == "backtrack" or ej >= 4
				if ej >= 4 or eb.DMG.Value*ep*4 < library.flags[GameTitle .. " Min Damage"] * 0.01 then
					return
				end
				if tick() - e2 > eb.FireRate.Value then
					e2 = tick()
					if library.flags[GameTitle .. " Shot Delay"] then
						wait(library.flags[GameTitle .. " Delay Amount"] * 0.001)
					end
					if eb.Name == "R8" then
						mouse2click()
					else
						mouse1click()
					end
				end
			end
			--e1:AddToggle({text = "Autowall", callback = function(State) if State then library.options["Aimbot Mode"]:SetValue"Silent" end end}):AddSlider({text = "Min Damage", min = 1, max = 100})
			--e1:AddToggle({text = "Body Aim"})
			--e1:AddToggle({text = "Shot Delay"}):AddSlider({text = "Amount", suffix = "ms", flag = "Delay Amount", min = 30, max = 1000})
			local et
			e1:AddToggle({text = "Anti-Aim", callback = function()
				while library and library.flags[GameTitle .. " Anti-Aim"] and wait() do
					if Client.Character and FFCoC(Client.Character, "Humanoid") and FFC(Client.Character, "HumanoidRootPart") then
						Client.Character.Humanoid.AutoRotate = false
						local eu = Client.Character.HumanoidRootPart
						local ev = library.flags[GameTitle .. " Pitch"] < 0 and -Camera.CFrame.LookVector or Camera.CFrame.LookVector
						local ew = CFrame.Angles(0, 0, 0)
						if library.flags[GameTitle .. " Yaw"] == "Manual" then
							ew = CFrame.Angles(0, math.rad(et == 1 and -90 or 90), 0)
						elseif library.flags[GameTitle .. " Yaw"] == "Auto" then
							if ce.X > WTSP(Camera, eu.Position + Vector3.new(ev.X * 5, 0, ev.Z * 5)).X then
								ew = CFrame.Angles(0, math.rad(-90), 0)
							else
								ew = CFrame.Angles(0, math.rad(90), 0)
							end
						end
						eu.CFrame = CFrame.new(eu.Position, eu.Position + Vector3.new(ev.X, 0, ev.Z)) * ew
					end
				end
				if Client.Character and FFCoC(Client.Character, "Humanoid") then
					Client.Character.Humanoid.AutoRotate = true
				end
			end})
			e1:AddSlider({text = "Pitch", value = 0, min = -1, max = 1, float = 0.1, callback = function(cB)
				if library.flags[GameTitle .. " Anti-Aim"] then
					RepStorage.Events.ControlTurn:FireServer(cB)
				end
			end})
			e1:AddList({text = "Yaw", values = {"Backwards", "Manual"}})
			e1:AddBind({text = "Yaw Left", key = "Left", callback = function()
				et = 1
			end})
			e1:AddBind({text = "Yaw Right", key = "Right", callback = function()
				et = 0
			end})
			local eH = {"5007348397", "5007348117", "5007347746", "5007347082"}
			local eE = MainColumn1:AddSection"Misc Cheats"
			--library.options["Aimbot Mode"]:AddValue"Silent"
			eE:AddToggle({text = "Wallbang"})
			--eE:AddToggle({text = "Always Headshot"})
			eE:AddToggle({text = "Hitsound"}):AddList({flag = "Hitsounds", values = {
				["Bameware"] = "3124331820",
				["Skeet"] = "4753603610",
				["Osu Combobreak"] = "3547118594",
				["The Ting Goes"] = function()
					return eH[math.random(1, 4)]
				end,
				["Bonk"] = "3765689841",
				["Oof"] = "4792539171",
				["Clink"] = "711751971",
				["CoD"] = "160432334",
				["Lazer Beam"] = "130791043",
				["Windows XP Error"] = "160715357",
				["Windows XP Ding"] = "489390072",
				["HL Med Kit"] = "4720445506",
				["HL Door"] = "4996094887",
				["HL Crowbar"] = "546410481",
				["HL Revolver"] = "1678424590",
				["HL Elevator"] = "237877850",
				["TF2 Hitsound"] = "3455144981",
				["TF2 Critical"] = "296102734",
				["TF2 Beepo"] = "3466987025",
				["TF2 Bat"] = "3333907347",
				["TF2 Pow"] = "679798995",
				["TF2 You Suck"] = "1058417264",
				["Quake Hitsound"] = "4868633804",
				["Fart"] = "131314452"
			}})
			eE:AddSlider({text = "Hitsound Volume", min = 0, max = 20, value = 2})

			eE:AddToggle({text = "Bhop", callback = function(cc)
				if cc then
					while library and library.flags[GameTitle .. " Bhop"] and wait() do
						if Client.Character and FFCoC(Client.Character, "Humanoid") then
							if inputService:IsKeyDown(Enum.KeyCode.Space) then
								Client.Character.Humanoid.Jump = true
							end
						end
					end
				end
			end}):AddSlider({text = "Speed", flag = "Bhop Speed", min = 20, max = 40})
			local eF = false
			--eE:AddButton({text = "Unlock Skins"})

			local ex = MainColumn1:AddSection"Weapon Mods"
			local ey = {}
			local function ez(aS, eA, G)
				if aS then
					for V, v in next, RepStorage.Weapons:GetDescendants() do
						if v.Name == eA then
							ey[v] = {value = v.Value}
							v.Value = G
							for eC, eD in next, v:GetChildren() do
								ey[eD] = {value = eD.Value}
								eD.Value = G
							end
						end
					end
				else
					for V, v in next, RepStorage.Weapons:GetDescendants() do
						if v.Name == eA and ey[v] then
							v.Value = ey[v].value
							for eC, eD in next, v:GetChildren() do
								eD.Value = ey[eD].value
							end
						end
					end
				end
			end
			--ex:AddToggle({text = "No Recoil"})
			--ex:AddToggle({text = "No Spread"})
			ex:AddToggle({text = "Inf Ammo", callback = function(cc)
				ez(cc, "Ammo", 9999)
				ez(cc, "StoredAmmo", 9999)
			end})
			ex:AddToggle({text = "Instant Reload", callback = function(cc)
				ez(cc, "ReloadTime", 0.1)
			end})
			ex:AddToggle({text = "Quickfire", callback = function(cc)
				ez(cc, "FireRate", 0.1)
			end})
			ex:AddToggle({text = "Quickdraw", callback = function(cc)
				ez(cc, "EquipTime", 0)
			end})
			ex:AddToggle({text = "Automatic Weapons", callback = function(cc)
				ez(cc, "Auto", true)
			end})

			VisualsMiscSection:AddToggle({text = "Bullet Tracers"}):AddSlider({text = "Lifetime", suffix = "s", min = 0.5, max = 5, float = 0.1}):AddColor({flag = "Bullet Tracer Color"})
			local eJ
			VisualsMiscSection:AddToggle({text = "Thirdperson", callback = function(State)
				if eJ then
					eJ = false
					if Client.Character then
						Client.CameraMinZoomDistance = 0
						Client.CameraMaxZoomDistance = 0
					end
				else
					library.options[GameTitle .. " TP Bind"].callback()
				end
			end}):AddSlider({text = "Distance", flag = "TP Distance", min = 5, max = 30}):AddBind({flag = "TP Bind", callback = function()
				if library.flags[GameTitle .. " Thirdperson"] then
					eJ = not eJ
					if eJ then
						while library and library.flags[GameTitle .. " Thirdperson"] and eJ and wait() do
							if Client.Character then
								Client.CameraMinZoomDistance = library.flags[GameTitle .. " TP Distance"]
								Client.CameraMaxZoomDistance = library.flags[GameTitle .. " TP Distance"]
							end
						end
						if Client.Character then
							Client.CameraMinZoomDistance = 0
							Client.CameraMaxZoomDistance = 0
						end
					end
				end
			end})
			VisualsMiscSection:AddToggle({text = "Transparent Arms"}):AddColor({flag = "Arms Color"})
			VisualsMiscSection:AddToggle({text = "Transparent Weapon"}):AddColor({flag = "Weapon Color"})
			library:AddConnection(Camera.ChildAdded, function(di)
				if di.Name == "Arms" then
					wait()
					if not FFC(di, "HumanoidRootPart") then return end
					di.HumanoidRootPart.Transparency = 1
					if library.flags[GameTitle .. " Transparent Arms"] then
						for u, di in next, di:GetChildren() do
							if string.find(di.Name, "Arms") then
								for u, eK in next, di:GetChildren() do
									eK.Material = "ForceField"
									eK.Color = library.flags[GameTitle .. " Arms Color"]
									eK.Transparency = 0.6
									local eL =
										FFC(eK, "Glove") or FFC(eK, "LGlove") or
										FFC(eK, "RGlove")
									if eL then
										eL.Material = "ForceField"
										eL.Mesh.VertexColor = Vector3.new(eK.Color.r, eK.Color.g, eK.Color.b)
										eL.Transparency = 0.4
									end
									if FFC(eK, "Sleeve") then
										eK.Sleeve.Mesh.VertexColor = Vector3.new(eK.Color.r, eK.Color.g, eK.Color.b)
										eK.Sleeve.Material = "ForceField"
										eK.Sleeve.Transparency = 0.6
									end
								end
							end
						end
					end
					if library.flags[GameTitle .. " Transparent Weapon"] then
						for u, d1 in next, di:GetChildren() do
							if d1:IsA "MeshPart" or d1:IsA "Part" then
								d1.Material = "ForceField"
								d1.Color = library.flags[GameTitle .. " Weapon Color"]
							end
						end
					end
				end
			end)
			VisualsMiscSection:AddToggle({text = "Viewmodel Changer"})
			VisualsMiscSection:AddSlider({text = "X Offset", value = 0, min = -20, max = 20})
			VisualsMiscSection:AddSlider({text = "Y Offset", value = 0, min = -20, max = 20})
			VisualsMiscSection:AddSlider({text = "Z Offset", value = 0, min = -20, max = 20})
			VisualsMiscSection:AddToggle({text = "Flip Y"})
			VisualsMiscSection:AddToggle({text = "Flip Z"})
			local eN
			VisualsMiscSection:AddToggle({text = "Color Correction", callback = function(cc)
				eN = FFC(Lighting, "Niggapenis")
				if not eN then
					eN = library:Create("ColorCorrectionEffect", {
						Name = "Niggapenis",
						TintColor = library.flags[GameTitle .. " Tint Color"],
						Brightness = 0,
						Parent = Lighting
					})
				end
				eN.Enabled = cc
			end}):AddColor({flag = "Tint Color", callback = function(aD)
				if eN then
					eN.TintColor = aD
				end
			end})
			local eP

			VisualsMiscSection:AddToggle({text = "Nightmode", callback = function(cc)
				eP = FFC(Lighting, "Nightmode")
				if not eP then
					eP = library:Create("ColorCorrectionEffect", {
						Name = "Nightmode",
						TintColor = Color3.fromRGB(255, 255, 255),
						Brightness = -0.2,
						Contrast = -0.2,
						Parent = Lighting
					})
				end
				eP.Enabled = cc
				while library and library.flags[GameTitle .. " Nightmode"] and wait() do
					Lighting.ClockTime = 4
				end
				Lighting.ClockTime = 12
			end})

			--No recoil
			RecoilFunc = CBClient.resetaccuracy
			--CBClient.resetaccuracy = function(...)
			--	if library.open then
			--		return
			--	end
			--	if library.flags[GameTitle .. " No Recoil"] then
			--		CBClient.resetaccuracy()
			--	end
			--	return RecoilFunc
			--end

		elseif GameTitle == "Strucid" then

			local StrucidTab = library:AddTab"Strucid":AddColumn()
			local StrucidMain = StrucidTab:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"

		elseif GameTitle == "Jailbreak" then

			--//local JailbreakTab = MainWindow:AddTab"Jailbreak"
			--//JailbreakTab:Init()
			--//library.options["Aimbot Mode"]:AddValue"Silent"
			--//local InfWallbang = JailbreakTab:AddToggle"Wallbang"

			--//Meta.__index = newcclosure(function(table, index)
			--//	if tostring(table) == "Tip" and index == "Position" and AimbotSilent.state and library.Aimbot.Position3d then
			--//		local Cast = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).Unit * library.flags["Aimbot Max Distance"])
			--//		local Hit, Position = workspace:FindPartOnRay(Cast, GetCharacter(Client))
			--//		if Hit then
			--//			return Position
			--//		end
			--//	end
			--//	return Old_index(table, index)
			--//end)

		elseif GameTitle == "MURDER" then

			local MurderTab = library:AddTab"MURDER":AddColumn()
			local MurderMain = MurderTab:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			MurderMain:AddToggle({text = "Wallbang"})
			--MurderMain:AddToggle({text = "Auto Grab Revolver", callback = function(State)
			--	if State then
			--		local Revolver = FFC(workspace.Debris, "Revolver")
			--		local Character = Players[Client].Character
			--		if Character and Revolver and Client.Status.Role.Value ~= "Murderer" and not Client.Status.HasRevolver.Value then
			--			local OldPosition = GBB(Character).Position
			--			local NewPos = GBB(Revolver).Position
			--			if (NewPos - OldPosition).Magnitude < 200 then
			--				Character:MoveTo(NewPos)
			--				wait(0.5)
			--				Character:MoveTo(OldPosition)
			--			end
			--		end
			--	end
			--end})
			MurderMain:AddButton({text = "Collect Loot", callback = function()
				local Character = Players[Client].Character
				if Character then
					local OldPosition = GBB(Character).Position
					for _,Prop in next, workspace.Debris.Props:GetChildren() do
						if FFC(Prop, "Green") and (Prop.Position - OldPosition).Magnitude < 200 then
							Character:MoveTo(Prop.Position)
							wait(0.5)
							RepStorage.Events.Loot:FireServer(Prop)
							wait(0.5)
						end
					end
					Character:MoveTo(OldPosition)
				end
			end})
			VisualsMiscSection:AddColor({text = "Murderer Color", color = Color3.new(1, 0, 0)})
			VisualsMiscSection:AddColor({text = "Detective Color", color = Color3.new(0, 0, 1)})

			library:AddConnection(workspace.Debris.ChildAdded, function(Child)
				wait(2)
				if Child.Name == "Revolver" and library.flags["Auto Grab Revolver"] then library.options["Auto Grab Revolver"].callback() end
			end)

		elseif GameTitle == "Ace Of Spadez" then

			local Events
			repeat wait(1) Events = FFC(RepStorage, "RemoteEvents") until Events

			local Say = {
				"You don't use uwuware? Okay bro,,, dot dot dot",
				"Did you seriously just die again?",
				"Yeah sorry, the owner made the chat spammer,,,",
				"Are you an ape and keep getting killed? Thought so.",
				"Looking for an easy W? Too bad monkey, ooh ah ah ooo",
				"Interested in what you see? Join the server: pBRqP4xT9P",
				"Have I died yet? No clue I'm just a chat spammer,,,",
				"Ok but fr fr bro, you need to get this,,, here's an invite: gyEehEx",
				"Inteque smells like cheese :|"
			}

			local WeaponSystem = Client.PlayerScripts.WeaponSystem
			local Gun = WeaponSystem.Gun

			local AceTab = library:AddTab"Ace of Spadez":AddColumn()
			local AceMain = AceTab:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			AceMain:AddToggle({text = "Wallbang"})
			AceMain:AddToggle({text = "Inf Ammo", callback = function(State)
				Gun.Ammo.Value = State and math.huge or Gun.Ammo.Max.Value
				Gun.Reserves.Value = State and math.huge or Gun.Reserves.Max.Value
			end})
			--AceWindow:AddToggle({text = "Infinite Grenades", callback = function(State)
			--	WeaponSystem.Explosive.Amount.Value = State and math.huge or WeaponSystem.Explosive.Amount.Max.Value
			--end})
			AceMain:AddToggle({text = "No Recoil"})

			local AceOther = AceTab:AddSection"Other"
			AceOther:AddToggle({text = "No Fog", callback = function(State)
				Lighting.FogStart = State and 0 or 325
				Lighting.FogEnd = State and 9e9 or 650
			end})
			AceOther:AddToggle({text = "No Fall Damage", callback = function(State)
				local Character = Players[Client].Character
				if State and Character then
					Character.Animate.FallDamageServer:Destroy()
				end
			end})
			AceOther:AddToggle({text = "Speed", callback = function(State)
				if State then
					while library and library.flags[GameTitle .. " Speed"] and wait() do
						local Character = Players[Client].Character
						if Character then
							Character.Humanoid.WalkSpeed = library.flags[GameTitle .. " Amount"]
						end
					end
				end
			end}):AddSlider({text = "Amount", min = 36, max = 300})
			AceOther:AddToggle({text = "Chat Spammer", callback =
				function(State)
					if State then
						while library and wait(5) and library.flags[GameTitle .. " Chat Spammer"] do
							Events.Chat.SendMessage:InvokeServer(Say[math.random(1, #Say)])
						end
					end
				end
			})

			library:AddConnection(Gun.Ammo.Changed, function()
				if library.flags[GameTitle .. " Inf Ammo"] then
					Gun.Ammo.Value = math.huge
				end
			end)

			library:AddConnection(Gun.Reserves.Changed, function()
				if library.flags[GameTitle .. " Inf Ammo"] then
					Gun.Reserves.Value = math.huge
				end
			end)

			--library:AddConnection(WeaponSystem.Explosive.Ammount.Changed, function()
			--	if library.flags["Infinite Grenades"] then
			--		WeaponSystem.Explosive.Ammount.Value = math.huge
			--	end
			--end)

			library:AddConnection(Client.CharacterAdded, function(Character)
				wait(1)
				if library.flags[GameTitle .. " No Fall Damage"] and Players[Client].Character then
					Character.Animate.FallDamageServer:Destroy()
				end
			end)

		elseif GameTitle == "Sound Space" then

			AimbotTab.canInit = false
			VisualsTab.canInit = false
			local SoundTab = library:AddTab"Sound Space":AddColumn()
			local SoundMain = SoundTab:AddSection"Main"
			local Loop
			SoundMain:AddToggle({text = "Auto Player", callback = function(State)
				if State then
					Loop = library:AddConnection(runService.RenderStepped, function()
						if FFC(workspace.Client, "Background") and FFC(workspace.Client.Background, "Squares") then
							if library.flags["Silent"] then
								workspace.Client.CameraPos.Position = Vector3.new(7, 3, 0)
							else
								if library.Aimbot.Target and not library.open then
									local Position, Vis = WTSP(Camera, Vector3.new(0.05, library.Aimbot.Position3d.Y, library.Aimbot.Position3d.Z))
									local X = Position.X - Mouse.X
									local Y = Position.Y - Mouse.Y
									if library.flags[GameTitle .. " Randomization"] then
										if X > 10 or Y > 10 then
											X = X + math.random(39, library.flags[GameTitle .. " Randomize Amount"])
											Y = Y + math.random(39, library.flags[GameTitle .. " Randomize Amount"])
										end
									end
									mousemoverel(X / library.flags[GameTitle .. " Smoothness"], Y / library.flags[GameTitle .. " Smoothness"])
								end
							end
							local Distance = 9e9
							for _,Square in next, workspace:GetDescendants() do
								if tonumber(Square.Name) then
									pcall(function()
										local NewDistance = (Square.Position - Camera.CFrame.p).Magnitude
										if NewDistance <= Distance then
											library.Aimbot.Target = Square
											Distance = NewDistance
										end
									end)
								end
							end
						end
					end)
				else
					Loop:Disconnect()
				end
			end})

			SoundMain:AddSlider({text = "Smoothness", min = 1, max = 50})
			SoundMain:AddToggle({text = "Randomization"})
			SoundMain:AddSlider({text = "Amount", min = 40, max = 100})
			--SoundMain:AddToggle({text = "Silent"})

			--Meta.__index = newcclosure(function(t, i)
			--	if checkcaller() then return Old_index(t, i) end
			--	if library.flags[GameTitle .. " Silent"] and library.Aimbot.Position3d then
			--		if tostring(getfenv(1).script) == "GameScript" then
			--			if t == Camera and i == "CFrame" then
			--				return CFrame.new(Vector3.new(7, 3, 0), Vector3.new(0.05, library.Aimbot.Position3d.Y, library.Aimbot.Position3d.Z))
			--			end
			--		end
			--	end

			--	return Old_index(t, i)
			--end)

		elseif GameTitle == "KAT" then

			--local KatTab = library:AddTab"KAT"
			--local KatColumn = KatTab:AddColumn()

			--local KatMain = KatColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			--//KatWindow:AddToggle({text = "Wallbang"})
			VisualsMiscSection:AddColor({text = "Murderer Color", color = Color3.new(1, 0, 0)})
			VisualsMiscSection:AddColor({text = "Sheriff Color", color = Color3.new(0, 0, 1)})

		elseif GameTitle == "MMC Zombies Project" then

			local MMCTab = library:AddTab"MMC ZP"
			local MMCColumn = MMCTab:AddColumn()
			local MMCColumn1 = MMCTab:AddColumn()
			local MMCMain = MMCColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			MMCMain:AddToggle({text = "Wallbang"})
			MMCMain:AddToggle({text = "Always Headshot"})
			MMCMain:AddToggle({text = "Speed"}):AddSlider({text = "Amount", min = 14, max = 50})

			local WeaponMods = MMCColumn1:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "No Recoil"})
			WeaponMods:AddToggle({text = "Automatic Weapons"})
			WeaponMods:AddToggle({text = "Quickdraw"})

			library:AddConnection(Client.Character.Humanoid.Changed, function()
				if library.flags["Speed"] then
					Client.Character.Humanoid.WalkSpeed = library.flags["Amount"]
				end
			end)

			local Event = RepStorage.conn.ev
			local Network = require(Client.PlayerScripts.framework.core.network)
			local Old_hit = Network.hit.send
			local GunSystem = require(Client.PlayerScripts.framework.core.gunsys)
			local Old_fire = GunSystem.fire

			AddTracker(workspace.map.enemies)

			Network.hit.send = function(b, c, d, e, f)
				if not library then return Old_hit(b, c, d, e, f) end
				if library.flags["Always Headshot"] then
					f = FFC(c.Parent, "Head") or f
					e = f.Position
				end
				Old_hit(b, c, d, e, f)
			end

			local Old_configs = {}
			for _, v in next, RepStorage.assets.guns:GetChildren() do
				for _, g in next, v:GetChildren() do
					Old_configs[g.Name] = require(g.config)
				end
			end

			GunSystem.fire = function(b, ...)
				if not library then return Old_fire(b, ...) end
				Old_config = Old_configs[b.model.Name]

				b.config.firing.semi = library.flags[GameTitle .. " Automatic Weapons"] and false or Old_config.firing.semi
				b.config.firing.auto = library.flags[GameTitle .. " Automatic Weapons"] and true or Old_config.firing.auto
				b.config.firing.mode = library.flags[GameTitle .. " Automatic Weapons"] and "auto" or Old_config.firing.mode

				b.config.recoil.hipfire.min = library.flags[GameTitle .. " No Recoil"] and CFrame.new() or Old_config.recoil.hipfire.min
				b.config.recoil.hipfire.max = library.flags[GameTitle .. " No Recoil"] and CFrame.new() or Old_config.recoil.hipfire.max
				b.config.recoil.ADS.min = library.flags[GameTitle .. " No Recoil"] and CFrame.new() or Old_config.recoil.ADS.min
				b.config.recoil.ADS.max = library.flags[GameTitle .. " No Recoil"] and CFrame.new() or Old_config.recoil.ADS.max
				b.config.recoil.camera.min = library.flags[GameTitle .. " No Recoil"] and CFrame.new() or Old_config.recoil.camera.min
				b.config.recoil.camera.max = library.flags[GameTitle .. " No Recoil"] and CFrame.new() or Old_config.recoil.camera.max

				b.config.equipTime = library.flags[GameTitle .. " Quickdraw"] and 0 or Old_config.equipTime

				Old_fire(b, ...)
			end

		elseif GameTitle == "Project Lazarus" then

			local LazarusTab = library:AddTab"Project Lazarus"
			local LazarusColumn = LazarusTab:AddColumn()
			local LazarusColumn1 = LazarusTab:AddColumn()
			local LazarusMain = LazarusColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			LazarusMain:AddToggle({text = "Wallbang"})
			LazarusMain:AddToggle({text = "Speed"}):AddSlider({text = "Multiplier", min = 1, max = 4, float = 0.1})

			AddTracker(workspace.Baddies)

			local OriginalValues = {}
			spawn(function()
				while wait(2) do
					for i,v in next, getgc(true) do
						if typeof(v) == "table" and rawget(v, "FireTime") then
							if not OriginalValues[v] then
								OriginalValues[v] = v
							end
							local old = OriginalValues[v]
							--print(old.Spread.Min)
							--v.MagSize = library.flags["Inf Ammo"] and math.huge or old.MagSize
							--v.MaxAmmo = library.flags["Inf Ammo"] and math.huge or old.MaxAmmo

							v.FireTime = library.flags[GameTitle .. " Quickfire"] and 0 or old.FireTime

							--v.Semi = library.flags["Full-auto"] and false or old.Semi
							--v.SingleAction = library.flags["Full-auto"] and false or old.SingleAction

							v.ShellReload = library.flags[GameTitle .. " Instant Reload"] and math.huge or old.ShellReload

							v.Spread.Min = library.flags[GameTitle .. " No Spread"] and 0 or old.Spread.Min
							v.Spread.Max = library.flags[GameTitle .. " No Spread"] and 0 or old.Spread.Max
							v.AimSpread = library.flags[GameTitle .. " No Spread"] and 0 or old.AimSpread

							--v.Drop.Start = library.flags["Inf Range"] and math.huge or require(old).Drop.Start
							--v.Drop.End = library.flags["Inf Range"] and math.huge or require(old).Drop.Start

							v.ViewKick.Pitch.Min = library.flags[GameTitle .. " No Recoil"] and 0 or old.ViewKick.Pitch.Min
							v.ViewKick.Pitch.Max = library.flags[GameTitle .. " No Recoil"] and 0 or old.ViewKick.Pitch.Max
							v.ViewKick.Yaw.Min = library.flags[GameTitle .. " No Recoil"] and 0 or old.ViewKick.Yaw.Min
							v.ViewKick.Yaw.Max = library.flags[GameTitle .. " No Recoil"] and 0 or old.ViewKick.Yaw.Max

							v.AimTime = library.flags["Fast Aim"] and 0 or old.AimTime

							v.GunKick = library.flags["No Gun-kick"] and 0 or old.GunKick

							v.BulletPenetration = library.flags[GameTitle .. " Oneshot"] and math.huge or old.BulletPenetration
							v.HeadShot = library.flags[GameTitle .. " Oneshot"] and math.huge or old.HeadShot
							v.TorsoShot = library.flags[GameTitle .. " Oneshot"] and math.huge or old.TorsoShot
							v.LimbShot = library.flags[GameTitle .. " Oneshot"] and math.huge or old.LimbShot

							v.MoveSpeed = library.flags[GameTitle .. " Speed"] and library.flags[GameTitle .. " Multiplier"] or old.MoveSpeed
							v.AimMoveSpeed = library.flags[GameTitle .. " Speed"] and library.flags[GameTitle .. " Multiplier"] or old.AimMoveSpeed
						end
					end
				end
			end)

			local WeaponMods = LazarusColumn1:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "Oneshot"})
			WeaponMods:AddToggle({text = "No Recoil"})
			WeaponMods:AddToggle({text = "No Spread"})
			WeaponMods:AddToggle({text = "No Gun-kick"})
			--WeaponMods:AddToggle({text = "Inf Ammo"})
			WeaponMods:AddToggle({text = "Quickfire"})
			WeaponMods:AddToggle({text = "Fast Aim"})
			WeaponMods:AddToggle({text = "Instant Reload"})
			--WeaponMods:AddToggle({text = "Full-Auto"})

		elseif GameTitle == "State Of Anarchy" then

			local SoATab = library:AddTab"State of Anarchy":AddColumn()

			local SoAMain = SoATab:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			SoAMain:AddToggle({text = "Wallbang"})
			--SoAWindow:AddToggle({text = "Always Headshot"})
			--SoAWindow:AddToggle({text = "No Recoil"})

			local AimHook
			AimHook = hookfunction(workspace.FindPartOnRayWithIgnoreList, function(self, ...)
				local Args = {...}
				if tostring(Args[2][1]) == "Projectiles" then
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).unit * library.flags["Aimbot Max Distance"])
					end
					if library.flags[GameTitle .. " Wallbang"] then
						local n = #Args[2]
						Args[2][n + 1] = workspace.Map
						Args[2][n + 2] = workspace.Terrain
					end
				end
				return AimHook(self, unpack(Args))
			end)

		elseif GameTitle == "Zombie Rush" then

			spawn(function()
				while library and wait(1) do
					for i,v in next, getreg() do
						if typeof(v) == "function" then
							local values = getupvalues(v)
							local func = values[6] and type(values[6]) == "function" and values[6]
							if func then
								local Weapon = getupvalue(func, 25)
								local Config = FFC(Client.Backpack, Weapon.Name)
								Config = Config or FFC(Client.Character, Weapon.Name)
								Config = Config and Config.Configuration
								setupvalue(func, 4, library.flags[GameTitle .. " Quickfire"] and 50 or Config.Firerate.Value) 
								setupvalue(func, 16, library.flags[GameTitle .. " No Spread"] and 0 or Config.Spread.Value) -- spread
								setupvalue(func, 26, library.flags[GameTitle .. " Automatic Weapons"] and true or Config.FullAuto.Value) -- automatic
							end
						end
					end
				end
			end)

			local ZRushTab = library:AddTab"Zombie Rush"
			local ZRushColumn = ZRushTab:AddColumn()
			--local ZRushColumn1 = ZRushTab:AddColumn()

			local ZRushMain = ZRushColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			ZRushMain:AddToggle({text = "Wallbang"})

			local WeaponMods = ZRushColumn:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "No Spread"})
			WeaponMods:AddToggle({text = "Quickfire"})
			WeaponMods:AddToggle({text = "Automatic Weapons"})

			AddTracker(workspace["Zombie Storage"])

		elseif GameTitle == "Zombie Attack" then

			local GunData = RepStorage:WaitForChild"GunData"
			GunData = require(GunData)

			local function ApplyMods()
				for i,v in next, getreg() do
					if typeof(v) == "function" then
						local values = getupvalues(v)
						if OldCallingScript().Name == "GunController" and #values >= 25 then
							local Data = GunData[values[1].Name]
							setupvalue(v, 12, library.flags[GameTitle .. " Automatic Weapons"] and true or Data.Automatic) 
							setupvalue(v, 23, library.flags[GameTitle .. " No Spread"] and 0 or Data.Spread.Min)
							setupvalue(v, 24, library.flags[GameTitle .. " No Spread"] and 0 or Data.Spread.Max)
						end
					end
				end
			end

			local ZAttackTab = library:AddTab"Zombie Attack"
			--local ZAttackColumn = ZAttackTab:AddColumn()
			local ZAttackColumn1 = ZAttackTab:AddColumn()

			--local ZAttackMain = ZAttackColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			--ZAttackWindow:AddToggle({text = "Wallbang"})
			--ZAttackWindow:AddToggle({text = "Always Headshot"})

			local WeaponMods = ZAttackColumn1:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "No Spread", callback = function() ApplyMods() end})
			WeaponMods:AddToggle({text = "Automatic Weapons", callback = function() ApplyMods() end})

			library:AddConnection(Client.Backpack.ChildAdded, function()
				wait(2)
				ApplyMods()
			end)

			local Connection
			library:AddConnection(Client.CharacterAdded, function(Char)
				Connection = library:AddConnection(Char.ChildAdded, function()
					wait(2)
					ApplyMods()
				end)
			end)

			AddTracker(workspace.enemies)
			AddTracker(workspace.BossFolder)

		elseif GameTitle == "Infection" then

			local InfectionTab = library:AddTab"Infection"
			local InfectionMain = InfectionTab:AddSection"Main"
			--library.options["Aimbot Mode"]:AddValue"Silent"
			--InfectionWindow:AddToggle({text = "Wallbang"})

			--aaa

		elseif GameTitle == "Resurrection" then

			local gc = getgc(true)
			spawn(function()
				while library do
					wait(1)
					for i,v in next, gc do
						if typeof(v) == "table" and rawget(v, "ammoleft") then
							if library.flags[GameTitle .. " Inf Ammo"] then
								v.ammoleft = library.flags[GameTitle .. " Inf Ammo"] and math.huge
								v.ammo = library.flags[GameTitle .. " Inf Ammo"] and math.huge
							else
								if v.ammoleft == math.huge then
									v.ammoleft = v.info.spareammo
									v.ammo = v.info.ammo
								end
							end
							v.automatic = library.flags[GameTitle .. " Automatic Weapons"] and true or v.info.automatic
							v.recoil = library.flags[GameTitle .. " No Recoil"] and 0 or v.info.recoil
							v.maxspread = library.flags[GameTitle .. " No Spread"] and 0 or 0.1
							v.minspread = library.flags[GameTitle .. " No Spread"] and 0 or 0.01
							v.RPM = library.flags[GameTitle .. " Quickfire"] and 1000 or v.info.RPM
						end
					end
				end
			end)

			local ResurrectionTab = library:AddTab"Resurrection"
			local ResurrectionColumn = ResurrectionTab:AddColumn()
			local ResurrectionColumn1 = ResurrectionTab:AddColumn()

			local ResurrectionMain = ResurrectionColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			ResurrectionMain:AddToggle({text = "Wallbang"})

			local WeaponMods = ResurrectionColumn1:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "No Recoil"})
			WeaponMods:AddToggle({text = "No Spread"})
			WeaponMods:AddToggle({text = "Quickfire"})
			WeaponMods:AddToggle({text = "Inf Ammo"})
			WeaponMods:AddToggle({text = "Automatic Weapons"})

			AddTracker(workspace.NPCs)

		elseif GameTitle == "Typical Colors 2" then

			local firebullet
			for _,Func in next, getgc() do
				if typeof(Func) == "function" then
					local Info = debug.getinfo(Func)
					if debug.getinfo(Func).name == "firebullet" then
						firebullet = Func
					end
				end
			end

			local TC2Tab = library:AddTab"Typical Colors 2":AddColumn()

			local TC2Main = TC2Tab:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			TC2Main:AddToggle({text = "Wallbang"})
			TC2Main:AddToggle({text = "Inf Jump"})
			TC2Main:AddToggle({text = "Quickfire"})

			local Jumping
			--local Quickfire
			local function StartLoop()
				--if Quickfire then
				--	while Quickfire and wait() do
				--		firebullet()
				--	end
				--end
				if Jumping then
					while library and Jumping and wait() do
						local Char = Players[Client].Character
						if Char then
							Char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end
				end
			end

			library:AddConnection(inputService.InputBegan, function(Input)
				if library.flags[GameTitle .. " Inf Jump"] and not inputService:GetFocusedTextBox() then
					if Input.KeyCode.Name == "Space" then
						Jumping = true
						StartLoop()
					end
					--if Input.UserInputType.Name == "MouseButton1" then
					--	Quickfire = true
					--	StartLoop()
					--end
				end
			end)

			library:AddConnection(inputService.InputEnded, function(Input)
				if Input.KeyCode.Name == "Space" then
					Jumping = false
				end
				--if Input.UserInputType.Name == "MouseButton1" then
				--	Quickfire = false
				--end
			end)

			local TC2ncall
			TC2ncall = hookmetamethod(game, "__namecall", function(self, ...)
				if checkcaller() then return TC2ncall(self, ...) end

				local Args = {...}
				local Method = getnamecallmethod()

				if Method == "FireServer" then
					if self.Name == "CreateProjectile" then
						if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
							Args[2] = library.Aimbot.Position3d
							Args[3] = CFrame.new(library.Aimbot.Position3d + Vector3.new(0, 0.5, 0))
							Args[5] = library.Aimbot.Position3d + Vector3.new(0, 0.5, 0)
						end
					end

				end

				if Method == "FindPartOnRayWithIgnoreList" then
					if library.flags[GameTitle .. " Wallbang"] and Args[2][1].Name == "Clips" then
						local n = #Args[2]
						Args[2][n + 1] = workspace.Map
					end
					if library.flags["Aimbot Mode"] == "Silent" and library.Aimbot.Position3d then
						Args[1] = Ray.new(Camera.CFrame.p, (library.Aimbot.Position3d - Camera.CFrame.p).Unit * library.flags["Aimbot Max Distance"])
					end
				end
				return TC2ncall(self, unpack(Args))
			end)

		elseif GameTitle == "Blackhawk Rescue Mission" then

			--local BRMTab = library:AddTab"Blackhawk Rescue Mission":AddColumn()
			--local BRMMain = BRMTab:AddSection"Main"

			library.options["Aimbot Mode"]:AddValue"Silent"
			--BRMMain:AddToggle({text = "Wallbang"})

			AddTracker(workspace.Custom["-1"])

		elseif GameTitle == "Shoot Out" then

			--local SOTab = library:AddTab"Shoot Out":AddColumn()
			--local SOMain = SOTab:AddSection"Main"

			library.options["Aimbot Mode"]:AddValue"Silent"
			--SOMain:AddToggle({text = "Wallbang"})

			local OldValues = {}
			local function ApplyMods()
				for i,v in next, getgc(true) do
					if typeof(v) == "table" and rawget(v, "ROF") and v ~= OldValues[v.NAME] then
						if not OldValues[v.NAME] then
							OldValues[v.NAME] = v
						end
						--for i2,v2 in next, v do print(i2, v2) end
						v.ROF = library.flags[GameTitle .. " Quickfire"] and math.huge or OldValues[v.NAME].ROF
						v.AUTOMATIC = library.flags[GameTitle .. " Automatic Weapons"] and true or OldValues[v.NAME].AUTOMATIC
						v.SPREAD = library.flags[GameTitle .. " No Spread"] and 0 or OldValues[v.NAME].SPREAD
						v.RECOIL_STRENGTH = library.flags[GameTitle .. " No Recoil"] and 0 or OldValues[v.NAME].RECOIL_STRENGTH
						v.RELOAD_TIME = library.flags[GameTitle .. " Fast Reload"] and 0 or OldValues[v.NAME].RELOAD_TIME
						--v.MAX_AMMO = library.flags[GameTitle .. " Inf Ammo"] and math.huge or OldValues[v.NAME].MAX_AMMO
					end
				end
			end

			--local WeaponMods = SOTab:AddSection"Weapon Mods"
			--WeaponMods:AddToggle({text = "No Recoil", callback = ApplyMods})
			--WeaponMods:AddToggle({text = "No Spread", callback = ApplyMods})
			--WeaponMods:AddToggle({text = "Quickfire", callback = ApplyMods})
			--WeaponMods:AddButton({text = "Inf Ammo", callback = function() ApplyMods() end})
			--WeaponMods:AddToggle({text = "Fast Reload", callback = ApplyMods})
			--WeaponMods:AddToggle({text = "Automatic Weapons", callback = ApplyMods})

			local function SetTeams()
				for i,v in next, getreg() do
					if typeof(v) == "table" and rawget(v, "Cowboys") then
						Cowboys = v.Cowboys
						Sheriffs = v.Sheriffs
					end
				end
			end
			SetTeams()

			spawn(function()
				while library and wait(5) do
					SetTeams()
				end
			end)

		elseif GameTitle == "Weaponry" then

			local Shoot, Recoil
			repeat wait(1)
				for i,v in next, getgc(true) do
					if typeof(v) == "function" and not is_synapse_function(v) then
						local info = debug.getinfo(v)
						if info.name == "EnableShoot" then
							Shoot = v
						elseif info.name == "RecoilEffects" then
							Recoil = v
						elseif info.name == "checkIsHitPlayerValid" then
							v = function() return true end
						end
					end
				end
			until Shoot and Recoil

			local Framework = getsenv(Client.PlayerScripts["Client_Major_Framework"])
			local PauseFunc = getconstant(Framework.PauseWeapon, 2)

			local WeaponryTab = library:AddTab"Weaponry"
			local WeaponryColumn = WeaponryTab:AddColumn()
			--local WeaponryColumn1 = WeaponryTab:AddColumn()

			local WeaponryMain = WeaponryColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			--WeaponryMain:AddToggle({text = "Wallbang"})

			local WeaponMods = WeaponryColumn:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "No Recoil"})
			WeaponMods:AddToggle({text = "No Spread"})
			WeaponMods:AddToggle({text = "Inf Ammo"})
			WeaponMods:AddToggle({text = "Inf Range"})
			WeaponMods:AddToggle({text = "Quickfire"})
			--WeaponMods:AddToggle({text = "High Velocity", callback = ApplyMods})
			--WeaponMods:AddToggle({text = "Automatic Weapons", callback = ApplyMods})

			local Stats = {}
			local ShootHook
			ShootHook = hookfunction(Shoot, function()
				local Values = getupvalues(ShootHook)
				local WeaponStats = Values[3]

				local RealStats = Stats[WeaponStats.WeaponName]
				if not RealStats then
					Stats[WeaponStats.WeaponName] = WeaponStats
					RealStats = Stats[WeaponStats.WeaponName]
				end

				if library.flags[GameTitle .. " No Spread"] then
					WeaponStats.CurrentAccuracy = 0
				end

				if library.flags[GameTitle .. " Inf Ammo"] then
					WeaponStats.CurrentAmmo = WeaponStats.MaxAmmo
				end

				if library.flags[GameTitle .. " Quickfire"] then
					WeaponStats.FireRate = 0
					WeaponStats.CanShoot = true
					WeaponStats.IsShooting = false
				else
					WeaponStats.FireRate = RealStats.FireRate
				end

				WeaponStats.Range = library.flags[GameTitle .. " Inf Range"] and 10000 or RealStats.Range

				return ShootHook()
			end)

			local RecoilHook
			RecoilHook = hookfunction(Recoil, function()
				return not library.flags[GameTitle .. " No Recoil"] and RecoilHook()
			end)

		elseif GameTitle == "Boxing Simulator" then

			AimbotTab.canInit = false
			VisualsTab.canInit = false

			local BSTab = library:AddTab"Boxing Simulator"
			local BSColumn = BSTab:AddColumn()
			local BSColumn1 = BSTab:AddColumn()

			local BSAutomation = BSColumn:AddSection"Automation"
			BSAutomation:AddToggle({text = "Punch", flag = "Auto Punch", callback = function(State)
				if State then
					while library and library.flags[GameTitle .. " Auto Punch"] and wait() do
						local Char = Client.Character
						if FFCoC(Char, "Humanoid") then
							local Tool = FFCoC(Char, "Tool")
							if Tool then
								Tool:Activate()
							else
								for i, v in next, Client.Backpack:GetChildren() do
									if v:IsA("Tool") then
										Char.Humanoid:EquipTool(v)
									end
								end
							end
						end
					end
				end
			end})
			BSAutomation:AddToggle({text = "Sell", flag = "Auto Sell", callback = function(State)
				if State then
					while library and library.flags[GameTitle .. " Auto Sell"] and wait(5) do
						RepStorage.Events.SellRequest:FireServer()
					end
				end
			end})
			BSAutomation:AddToggle({text = "Capture Flags", flag = "ACF", callback = function(State)
				if State then
					while library and library.flags[GameTitle .. " ACF"] and wait(1) do
						local Char = Client.Character
						if FFC(Char, "HumanoidRootPart") then
							for i,v in next, workspace.Flags:GetChildren() do
								if v.Flag.Player.Info.PlayerName.Text ~= Client.Name then
									Char.HumanoidRootPart.CFrame = v.Hitbox.CFrame + Vector3.new(0, 5, 0)
									wait(10)
								end
							end
						end
					end
				end
			end})
			BSAutomation:AddToggle({text = "Collect", flag = "Collect", callback = function(State)
				if State then
					while library and library.flags[GameTitle .. " Collect"] and wait() do
						local Char = Client.Character
						if FFC(Char, "HumanoidRootPart") then
							if library.flags[GameTitle .. " C Filter"]["Coins"] then
								for i,v in next, workspace.Coins:GetChildren() do
									v.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame
								end
							end
							if library.flags[GameTitle .. " C Filter"]["Event Items"] then
								for i,v in next, workspace.Canes:GetChildren() do
									v.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame
								end
							end
						end
					end
				end
			end}):AddList({text = "Filter", flag = "C Filter", values = {"Coins", "Event Items"}, multiselect = true})

			local GlovesRemote = FFC(RepStorage.Events, "BuyAllGlove")
			local DNARemote = FFC(RepStorage.Events, "BuyAllDNA")
			local ClassRemote = FFC(RepStorage.Events, "BuyClass")
			BSAutomation:AddToggle({text = "Upgrade", flag = "Upgrade", callback = function(State)
				if State then
					while library and library.flags[GameTitle .. " Upgrade"] and wait(1) do
						if library.flags[GameTitle .. " U Filter"]["Gloves"] then
							GlovesRemote:FireServer()
						end
						if library.flags[GameTitle .. " U Filter"]["DNA"] then
							DNARemote:FireServer()
						end
						if library.flags[GameTitle .. " U Filter"]["Class"] then
							for i = 1,30 do
								ClassRemote:FireServer(i)
								wait(0.1)
							end
						end
					end
				end
			end}):AddList({text = "Filter", flag = "U Filter", values = {"Gloves", "DNA", "Class"}, multiselect = true})

			local FarmingSection = BSColumn:AddSection"Farming"
			--FarmingSection:AddToggle({text = "Enabled", flag = "Farming"})

		elseif GameTitle == "Citadel Of Adun" then

			spawn(function()
				while library and wait(5) do
					local CPos = Client.PlayerGui.CursorGui:WaitForChild"Mouse":WaitForChild"Icon".AbsolutePosition
					local CSize = Client.PlayerGui.CursorGui.Mouse.Icon.AbsoluteSize / 2
					library.options["MXO Amount"]:SetValue((Mouse.X <= CPos.X and (CPos.X - Mouse.X) or (Mouse.X - CPos.X)) + CSize.X)
					library.options["MYO Amount"]:SetValue((Mouse.Y <= CPos.Y and (Mouse.Y - CPos.Y) or (CPos.Y - Mouse.Y)) + CSize.Y)
				end
			end)

		elseif GameTitle == "Dust" then

			local Retards = {
			}

			for _, Player in next, game.Players:GetChildren() do
				if Retards[Player.UserId] then
					library:SendNotification(10, "A " .. Retards[Player.UserId] .. "(" .. Player.Name .. ") is in your game!")
				end
			end

			library:AddConnection(game.Players.PlayerAdded, function(Player)
				if Retards[Player.UserId] then
					library:SendNotification(10, "A " .. Retards[Player.UserId] .. "(" .. Player.Name .. ") has joined your game!")
				end
			end)

		elseif GameTitle == "BIG Paintball" then

			local FireFunc
			repeat wait(1)
				for i,v in next, getgc(true) do
					if type(v) == "table" and rawget(v, "Projectiles") then
						FireFunc = v.Projectiles.Fire
					end
				end
			until FireFunc

			local o
			o = hookfunction(FireFunc, function(Player, CF, ...)
				if library and library.flags["Aimbot Mode"] == "Silent" then
					if Player == Client and library.Aimbot.Position3d then
						CF = CFrame.new(CF.Position, library.Aimbot.Position3d)
					end
				end
				return o(Player , CF, ...)
			end)

			--gun mods
			local DefaultGunStats = {}
			for i,v in next, RepStorage.Framework.Modules["1 | Directory"].Guns:GetChildren() do
				if v.ClassName == 'ModuleScript' then
					local gunModule = require(v)
					for aa, bb in next, gunModule do
						gunModule = bb
					end

					DefaultGunStats[v.Name] = {
						automatic = gunModule.automatic or nil;
						shotrate = gunModule.shotrate or nil;
						velocity = gunModule.velocity or nil;
					}
				end
			end

			function UpdateGunMod()
				for i,v in next, RepStorage.Framework.Modules["1 | Directory"].Guns:GetChildren() do
					if v.ClassName == 'ModuleScript' then
						local gunModule = require(v)
						for aa, bb in next, gunModule do
							gunModule = bb
						end
						gunModule.automatic = library.flags[GameTitle .. " Automatic Weapons"] or DefaultGunStats[v.Name]["automatic"]
						gunModule.shotrate = library.flags[GameTitle .. " Quickfire"] and 0 or DefaultGunStats[v.Name]["shotrate"]
						gunModule.velocity = library.flags[GameTitle .. " Instant Hit"] and 9e9 or DefaultGunStats[v.Name]["velocity"]
					end
				end
			end

			local BPTab = library:AddTab"BIG Paintball"
			local BPColumn = BPTab:AddColumn()
			--local BPColumn1 = BPTab:AddColumn()

			--local BPMain = BPColumn:AddSection"Main"
			library.options["Aimbot Mode"]:AddValue"Silent"
			--BPMain:AddToggle({text = "Wallbang"})

			local WeaponMods = BPColumn:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "Quickfire", callback = UpdateGunMod})
			WeaponMods:AddToggle({text = "Instant Hit", callback = UpdateGunMod})
			WeaponMods:AddToggle({text = "Automatic Weapons", callback = UpdateGunMod})

		elseif GameTitle == "Giant Survival" then

			AimbotTab.canInit = false
			VisualsTab.canInit = false
			--gun mods
			local DefaultGunStats = {}
			local gunModule = require(RepStorage.Framework.Modules["7 | Weapon"])
			for i, v in next, gunModule.weapons do
				DefaultGunStats[v.name] = {auto = v.auto, rate = v.rate, velocity = v.velocity}
			end	

			function UpdateGunMod()
				for i, v in next, gunModule.weapons do
					v.auto = library.flags[GameTitle .. " Automatic Weapons"] or DefaultGunStats[v.name]["auto"]
					v.rate = library.flags[GameTitle .. " Quickfire"] and 0 or DefaultGunStats[v.name]["rate"]
					v.velocity = library.flags[GameTitle .. " Instant Hit"] and 9e9 or DefaultGunStats[v.name]["velocity"]
				end
			end

			local GSTab = library:AddTab"BIG Paintball"
			local GSColumn = GSTab:AddColumn()
			local GSColumn1 = GSTab:AddColumn()

			local GSMain = GSColumn:AddSection"Main"
			GSMain:AddList({text = "Equip Gun", values = {"Crazy Futuristic Minigun","Black Hole Gun","Golden Pistol", "Biochemical Blaster","Space Rifle","Ray Gun","SCAR","Lava Pistol","Sniper Rifle","Minigun","Plunger Rifle", "SMG","Double Barrel Shotgun","Fireworks Launcher","Paintball Gun","Potato Launcher","Banana Pistol","Revolver","Slingshot","Crossbow"}, max = 10, callback = function(Value)
				workspace["__THINGS"]["__REMOTES"].weaponequipped:FireServer({{Value}, {false}})
				if FFCoC(Client.Character, "Humanoid") then
					Client.Character.Humanoid.Health = 0
				end
			end})
			GSMain:AddList({text = "Equip Gear", values = {"Infinity Coil","Cash Magnet","Super Speed Coil","Super Gravity Coil","Speed Coil","Gravity Coil"}, max = 10, callback = function(Value)
				workspace["__THINGS"]["__REMOTES"].gearequipped:FireServer({{Value}, {false}})
				if FFCoC(Client.Character, "Humanoid") then
					Client.Character.Humanoid.Health = 0
				end
			end})
			--BPMain:AddToggle({text = "Wallbang"})

			local WeaponMods = GSColumn1:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "Quickfire", callback = UpdateGunMod})
			WeaponMods:AddToggle({text = "Instant Hit", callback = UpdateGunMod})
			WeaponMods:AddToggle({text = "Automatic Weapons", callback = UpdateGunMod})

		elseif GameTitle == "Lumberjack Legends" then
			AimbotTab.canInit = false
			VisualsTab.canInit = false

			local LLTab = library:AddTab"Lumberjack Legends"
			local LLColumn = LLTab:AddColumn()
			local LLColumn1 = LLTab:AddColumn()

			local LLMain = LLColumn:AddSection"Main"
			LLMain:AddButton({text = "Massive Backpack", callback = function()
				RepStorage.EquipBackpackRequest:InvokeServer(79)
			end})
			local EquipToolRequest = RepStorage.EquipToolRequest
			LLMain:AddButton({text = "Equip your best Axe", callback = function()
				local AxeValue = Client.leaderstats["Axe Level"].Value
				for i = AxeValue, 158 do
					EquipToolRequest:InvokeServer(Client.Character:WaitForChild("Axe"), i)
				end
			end})

			local LLAutomation = LLColumn1:AddSection"Automation"
			LLAutomation:AddToggle({text = "Collect Coins", callback = function()
				while library and library.flags[GameTitle .. "Collect Coins"] do
					wait(2.5)
					if Client.Character and FFC(Client.Character, "HumanoidRootPart") then
						for i,v in next, workspace.Village.CoinSpawnHolderV2:GetChildren() do 
							if v.Name == "CoinSpawn" then
								v.CFrame = Client.Character.HumanoidRootPart.CFrame
							end
						end
						for i,v in next, workspace.Worlds:GetChildren() do
							if FFC(v, "CoinSpawnHolder") then
								for z,x in next, v.CoinSpawnHolder:GetChildren() do 
									if x.Name == "CoinSpawn" then
										x.CFrame = Client.Character.HumanoidRootPart.CFrame
									end
								end
							end
						end
					end
				end
			end})

		elseif GameTitle == "Magnet Simulator" then



		elseif GameTitle == "Death Zone" then

			getsenv(Client.Backpack:WaitForChild(" ")).boom = function() end

			library:AddConnection(Client.CharacterAdded, function(Char)
				Char:WaitForChild"FallDamage":Destroy()
			end)
			delay(1, function()
				Players[Client].Character:WaitForChild"FallDamage":Destroy()
			end)

			local DZTab = library:AddTab"Death Zone"
			local DZColumn = DZTab:AddColumn()
			local DZColumn1 = DZTab:AddColumn()

			library.options["Aimbot Mode"]:AddValue"Silent"

			local DZMain = DZColumn:AddSection"Main"
			DZMain:AddToggle({text = "Thirdperson", callback = function(State)
				if State then
					library:AddConnection(runService.RenderStepped, "Thirdperson", function()
						if library and library.flags[GameTitle .. " Thirdperson"] then
							Client.CameraMaxZoomDistance = library.flags[GameTitle .. " TP Distance"]
							Client.CameraMinZoomDistance = library.flags[GameTitle .. " TP Distance"]
						else
							library.connections["Thirdperson"]:Disconnect()
						end
					end)
				else
					Client.CameraMaxZoomDistance = 0
					Client.CameraMinZoomDistance = 0
				end
			end}):AddSlider({text = "Distance", flag = "TP Distance", min = 10, max = 50})
			DZMain:AddToggle({text = "Speed"}):AddSlider({text = "Amount", flag = "Speed Amount", min = 10, max = 100})
			DZMain:AddToggle({text = "Jump Power", callback = function(State)
				if State then
					library:AddConnection(runService.RenderStepped, "Jump", function()
						if library and library.flags[GameTitle .. " Jump Power"] then
							local Char = Players[Client].Character
							Char = Char and FFCoC(Char, "Humanoid")
							if Char then
								Char.JumpPower = library.flags[GameTitle .. " Jump Amount"]
							end
						else
							library.connections["Jump"]:Disconnect()
							local Char = Players[Client].Character
							Char = Char and FFCoC(Char, "Humanoid")
							if Char then
								Char.JumpPower = 50
							end
						end
					end)
				end
			end}):AddSlider({text = "Amount", flag = "Jump Amount", min = 50, max = 300})

			local OldWeaponValues = {}
			for _,v in next, RepStorage.GunSettings:GetChildren() do
				OldWeaponValues[v.Name] = {}
				for i,v2 in next, require(v) do
					if i ~= "aimoffset" then
						OldWeaponValues[v.Name][i] = v2
					end
				end
			end

			local AimOffsets = {
				["M1911"] = CFrame.new(-0.453000009, 0.601499975, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["M16"] = CFrame.new(-0.349999994, 0.294999987, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["870MCS"] = CFrame.new(-0.349999994, 0.449999988, 1.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["ACWR"] = CFrame.new(-0.35800001, 0.215000004, 0.800000012, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["AEK971"] = CFrame.new(-0.344999999, 0.402999997, 1.70000005, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["AK74M"] = CFrame.new(-0.349999994, 0.400000006, 1.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["ASVAL"] = CFrame.new(-0.353500009, 0.40200001, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["AUG"] = CFrame.new(-0.342500001, 0.104000002, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["Beretta"] = CFrame.new(-0.451000005, 0.456, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["M1014"] = CFrame.new(-0.356999993, 0.414999992, 1.35000002, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["Magnum"] = CFrame.new(-0.456200004, 0.262400001, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["P90"] = CFrame.new(-0.364499986, 0.0500000007, 1.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["SCARL"] = CFrame.new(-0.352499992, 0.218999997, 0.600000024, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["SPAS12"] = CFrame.new(-0.349999994, 0.375, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["AWP"] = CFrame.new(-0.354999989, 0.451000005, 0.800000012, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["Minigun"] = CFrame.new(-0.364499986, 0.0500000007, 1.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["Deagle"] = CFrame.new(-0.453000009, 0.601499975, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["PPSH41"] = CFrame.new(-0.353500009, 0.40200001, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
			}

			local gc = getgc(true)
			spawn(function()
				while library do
					wait(2)
					for _,v in next, gc do
						if type(v) == "table" and rawget(v, "aimoffset") then
							for i,v2 in next, AimOffsets do
								if v2 == v.aimoffset and library then
									v.rpm = library.flags[GameTitle .. " Quickfire"] and 9e9 or OldWeaponValues[i].rpm
									v.auto = library.flags[GameTitle .. " Automatic Weapons"] and true or OldWeaponValues[i].auto
									v.recoil = library.flags[GameTitle .. " No Recoil"] and 0 or OldWeaponValues[i].recoil
									v.spread = library.flags[GameTitle .. " No Spread"] and 0 or OldWeaponValues[i].spread
									v.reloadtime = library.flags[GameTitle .. " Fast Reload"] and 0 or OldWeaponValues[i].reloadtime
									v.walkspeed = library.flags[GameTitle .. " Speed"] and library.flags[GameTitle .. " Speed Amount"] or OldWeaponValues[i].walkspeed
									v.runspeed = library.flags[GameTitle .. " Speed"] and library.flags[GameTitle .. " Speed Amount"] or OldWeaponValues[i].runspeed
								end
							end
						end
					end
				end
			end)

			local WeaponMods = DZColumn1:AddSection"Weapon Mods"
			WeaponMods:AddToggle({text = "No Recoil"})
			WeaponMods:AddToggle({text = "No Spread"})
			WeaponMods:AddToggle({text = "Quickfire"})
			WeaponMods:AddToggle({text = "Fast Reload"})
			WeaponMods:AddToggle({text = "Automatic Weapons"})

			local Teleporting
			local function TeleportTo(Position)
				if Teleporting then return end
				Teleporting = true
				local Char = Players[Client].Character
				Char = Char and FFC(Char, "HumanoidRootPart")
				if Char then
					local Pos = Char.Position
					Char.Anchored = true
					local step = 20
					for i=1,step do
						Char.CFrame = CFrame.new(Vector3.new(Pos.X, 3000, Pos.Z), Char.CFrame.LookVector):lerp(Char.CFrame, step)
					end
					for i=1,step do
						Char.CFrame = CFrame.new(Vector3.new(Position.X, 3000, Position.Z), Char.CFrame.LookVector):lerp(Char.CFrame, step)
					end
					for i=1,step do
						Char.CFrame = CFrame.new(Position, Char.CFrame.LookVector):lerp(Char.CFrame, step)
					end
					--[[
					wait(1)
					Char.CFrame = CFrame.new(Vector3.new(Position.X, 2000, Position.Z), Char.CFrame.LookVector)
					wait(1)
					Char.CFrame = CFrame.new(Vector3.new(Pos.X, 2000, Pos.Z), Char.CFrame.LookVector)
					wait(1)
					Char.CFrame = CFrame.new(Pos, Char.CFrame.LookVector)
					--]]
					Char.Anchored = false
					wait(1)
				end
				Teleporting = false
			end

			
			local function BringItems(Type, Name)
				for _, v in next, workspace.Items:GetChildren() do
					if v.Config.Type.Value == Type then
						if Name then
							if Type == "Attachment" then
								if not FFC(v.Config.GunsCompatibility, Name) then
									continue
								end
							else
								if not v.Config.ItemName.Value:find(Name) then
									continue
								end
							end
						end
						TeleportTo(v.MainPart.Position)
					end
				end
			end
			
			local WeaponItems = {
				"M1911", "Beretta", "Magnum", "Deagle", 
				"M1014", "SPAS-12", "870MCS",
				"P90", "PPSh-41", "AS Val", "M16", "SCAR-L", "AUG", "ACW-R",
				"Minigun", "AWP"
			}

			local ItemTab = DZColumn1:AddSection"Items"
			ItemTab:AddButton({text = "Bring Consumables", callback = function()
				BringItems"Consumable"
			end})

			ItemTab:AddList({text = "Weapons", skipflag = true, value = "", values = WeaponItems, max = 10, callback = function()
				BringItems("Weapon", Value)
			end})
			ItemTab:AddButton({text = "Bring Ammo", callback = function()
				BringItems("Ammo", library.flags[GameTitle .. " Weapons"])
			end})
			ItemTab:AddButton({text = "Bring Comp. Attachments", callback = function()
				BringItems("Attachment", library.flags[GameTitle .. " Weapons"])
			end})

			ItemTab:AddList({text = "Helmets", skipflag = true, value = "", values = {"Civilian", "Military", "Spec Ops", "Gas Mask", "Night Vision"}, callback = function(Value)
				BringItems("Helmet", Value)
			end})

			ItemTab:AddList({text = "Vests", skipflag = true, value = "", values = {"Civilian", "Military", "Spec Ops"}, callback = function(Value)
				BringItems("Vest", Value)
			end})

			ItemTab:AddList({text = "Backpacks", skipflag = true, value = "", values = {"Civilian", "Military", "Spec Ops"}, callback = function(Value)
				BringItems("Backpack", Value)
			end})
			--]]

		elseif GameTitle == "R2DA" then

			AddTracker(workspace.Characters.Zombies)

		elseif GameTitle == "Zombie Uprising" then

			local ZUprisingTab = library:AddTab"Zombie Uprising"
			local ZUprisingColumn = ZUprisingTab:AddColumn()

			local ZUprisingMain = ZUprisingColumn:AddSection"Main"
			local WeaponMods = ZUprisingColumn:AddSection"Weapon Mods"

			AddTracker(workspace.Zombies)
			AddTracker(workspace.Map.BossFolder)

		end
	end)

	library.flagprefix = nil

	if VisualsTab.canInit then
		AddTracker(PlayerServ)
	end

	--Always running
	library:AddConnection(runService.RenderStepped, function()
		local MX, MY = Mouse.X, Mouse.Y + 36
		if library.flags["Mouse Offset"] then
			MX = MX + library.flags["MXO Amount"]
			MY = MY + library.flags["MYO Amount"]
		end

		if Draw.Visible then
			Draw.Position = Vector2.new(MX, MY)
		end

		--if RadarWindow.Visible then
		--	RadarWindow.Position = Vector2.new(MX, MY)
		--end

		if CrosshairBottom.Visible then
			local Thickness = library.flags["Crosshair Thickness"] / 2
			local TX, TY = MX - Thickness, MY - Thickness
			CrosshairTop.Position = Vector2.new(TX, MY - library.flags["Crosshair Gap"])
			CrosshairLeft.Position = Vector2.new(MX - library.flags["Crosshair Gap"], TY)
			CrosshairRight.Position = Vector2.new(MX + library.flags["Crosshair Gap"], TY)
			CrosshairBottom.Position = Vector2.new(TX, MY + library.flags["Crosshair Gap"])
		end
		
		Lighting.ClockTime = library.flags["Clock Time"] and library.flags["Clock Time Amount"] or LightingSpoof.ClockTime
		Lighting.Brightness = library.flags["Brightness"] and library.flags["Brightness Amount"] or LightingSpoof.Brightness
		Lighting.Ambient = library.flags["Ambient Lighting"] and library.flags["Indoor Ambient"] or LightingSpoof.Ambient
		Lighting.OutdoorAmbient = library.flags["Ambient Lighting"] and library.flags["Outdoor Ambient"] or LightingSpoof.OutdoorAmbient
		Lighting.ColorShift_Top = library.flags["Color Shift"] and library.flags["Color Shift Top"] or LightingSpoof.ColorShift_Top

		Camera.FieldOfView = (library.flags["FOV Zoom Enabled"] and library.flags["FOV Zoom Key"] and (50 - library.flags["FOV Zoom Amount"])) or library.flags["FOV Changer"] and (library.flags["Dynamic Custom FOV"] and (CameraSpoof.FieldOfView + library.flags["FOV Amount"]) or library.flags["FOV Amount"]) or CameraSpoof.FieldOfView
	end)

	library:Init()

	delay(1, function() library:LoadConfig(tostring(getgenv().autoload)) end)

	if not getgenv().silent then
		if Loaded then
			library:SendNotification(5, "Loaded " .. (GameTitle or "universal features") .. " successfully")
		else
			library:SendNotification(5, "Failed to load " .. (GameTitle or "universal features") .. " (error copied to clipboard)")
			setclipboard(LoadError)
		end
	end

	if not library:GetConfigs()[1] then
		writefile(library.foldername .. "/Default" .. library.fileext, loadstring(game:HttpGet("https://raw.githubusercontent.com/Jan5106/uwuware_final/main/default_config.lua", true))())
		library.options["Config List"]:AddValue"Default"
		library:LoadConfig"Default"
	end
