import Foundation
import Desktop
import Lua

final class Window: Lua.CustomType {
    
    private let _win: Desktop.Window?
    var win: Desktop.Window { return _win! }
    
    class func metatableName() -> String { return "Window" }
    
    init(_ win: Desktop.Window) {
        _win = win
    }
    
    init?(_ win: Desktop.Window?) {
        if win == nil { return nil }
        _win = win
    }
    
    func title(vm: Lua.VirtualMachine) -> Lua.ReturnValue {
        return .Value(win.title())
    }
    
    func topLeft(vm: Lua.VirtualMachine) -> Lua.ReturnValue {
        return .Value(win.topLeft())
    }
    
    func setTopLeft(vm: Lua.VirtualMachine) -> Lua.ReturnValue {
        let point = NSPoint(fromLua: vm, at: 1)!
        win.setTopLeft(point)
        return .Nothing
    }
    
    class func allWindows(vm: Lua.VirtualMachine) -> Lua.ReturnValue {
        return .Values(Desktop.Window.allWindows().map{UserdataBox(Window($0))})
    }
    
    class func focusedWindow(vm: Lua.VirtualMachine) -> Lua.ReturnValue {
        return .Value(Lua.UserdataBox(Window(Desktop.Window.focusedWindow())))
    }
    
    class func classMethods() -> [(String, [Lua.TypeChecker], Lua.VirtualMachine -> Lua.ReturnValue)] {
        return [
            ("allWindows", [], Window.allWindows),
            ("focusedWindow", [], Window.focusedWindow),
        ]
    }
    
    class func instanceMethods() -> [(String, [Lua.TypeChecker], Window -> Lua.VirtualMachine -> Lua.ReturnValue)] {
        return [
            ("title", [], Window.title),
            ("topLeft", [], Window.topLeft),
            ("setTopLeft", [NSPoint.arg()], Window.setTopLeft),
        ]
    }
    
    class func setMetaMethods(inout metaMethods: Lua.MetaMethods<Window>) {
        metaMethods.eq = { $0.win.id() == $1.win.id() }
    }
    
}
