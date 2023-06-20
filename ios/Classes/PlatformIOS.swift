import UIKit

/// PlatformIOS class
public class PlatformIOS {
    // Check if clipboard is available
    static func getPlatformVersion() -> String{
        return UIDevice.current.systemVersion
    }
}
