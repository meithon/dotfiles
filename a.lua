local function to_upper_camel_case(str)
	local words = {}

	for word in str:gmatch("%S+") do
		for sub_word in word:gmatch("([^_%-%s]+)") do
			local first_char = sub_word:sub(1, 1):upper()
			local rest_chars = sub_word:sub(2):lower()
			table.insert(words, first_char .. rest_chars)
		end
	end

	return table.concat(words)
end

-- Example cases
local examples = {
	"hello world", -- Simple space-separated words
	"hello_world", -- Underscore-separated words
	"hello-world", -- Hyphen-separated words
	"hElLo WoRLd", -- Mixed case
	"hello's world", -- Contains apostrophe
}

for _, example in ipairs(examples) do
	print(to_upper_camel_case(example))
	-- Outputs:
	-- HelloWorld
	-- HelloWorld
	-- HelloWorld
	-- HelloWorld
	-- HelloSWorld
end
--
-- local str = "add(1,2) subtract(3, 4) multiply(5, 6)"
-- local result = string.gsub(str, "%b()", "")
-- print("result: ", result) -- 出力: " "
