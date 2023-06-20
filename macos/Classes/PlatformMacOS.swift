import Cocoa

// PlatformMacOS class
public class PlatformMacOS {
    // Check if clipboard is available
    static func getPlatformVersion() -> String{
        return ProcessInfo.processInfo.operatingSystemVersionString
    }
}
