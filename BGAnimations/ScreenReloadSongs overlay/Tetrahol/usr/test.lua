class 'Test' {
	print = function(self, text)
		lua.ReportScriptError(tostring(text))
	end
}

class 'Test2' : extends 'Test' {
	print = function(self, text)
		lua.ReportScriptError(tostring(text)..' 2')
	end
}

class 'Test3' : extends 'Test' {
	print = function(self)
		lua.ReportScriptError(tostring(self))
	end
}
