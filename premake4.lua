-- remove leading and trailing whitespace
function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--
-- Configuring wordcloud
--

	solution "wordcloud"
		language       "D"
		location       (_OPTIONS["to"])
		targetdir      (_OPTIONS["to"])
		flags          { "ExtraWarnings", "Symbols" }
		buildoptions   { "-wi -property" }
		configurations { "Optimize", "Tests" }
		platforms      { "x64" }
		libs = string.gsub(trim(os.outputof("gdlib-config --libs")), "-l", "-L-l")
		gdflags = "-L-L" .. trim(os.outputof("gdlib-config --libdir"))
		linkoptions    { gdflags, "-L-lgd", libs }
		files          { "src/*.d" }

	configuration "*Optimize*"
		flags          { "Optimize" }
		buildoptions   { "-d", "-noboundscheck", "-inline" }

	configuration "*Tests*"
		buildoptions   { "-unittest" }

	project "wordcloud"
		kind        "ConsoleApp"

--
-- Use the --to=path option to control where the project files get generated.
--

	newoption {
		trigger = "to",
		value   = "path",
		description = "Set the output location for the generated files"
	}

	newaction {
		trigger     = "uncrustify",
		description = "Check for code style",
		execute     = function ()
			print(os.outputof([[find src/ -name "*.d" -printf "uncrustify -c .style.cfg -f %p | diff -u %p -\n" | sh]]))
		end
	}

--
-- A more thorough cleanup.
--

	if _ACTION == "clean" then
		os.rmdir("bin")
		os.rmdir("obj")
	end
