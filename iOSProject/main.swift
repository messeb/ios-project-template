import Foundation
import UIKit

/// Custom main.swift to prevent app execution in the unit test.
/// Overwrites the app delegate with an empty implementation.

private let argc = CommandLine.argc
private let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(
        to: UnsafeMutablePointer<Int8>?.self,
        capacity: Int(CommandLine.argc)
)

// Could also be `nil` after the documentation
private let principalClassName = NSStringFromClass(UIApplication.self)

#if DEBUG
extension ProcessInfo {

    private var isRunningTests: Bool {
        return arguments.contains("IS_RUNNING_TESTS")
    }

    /// Returns the proper app delegate type for the debug configuration
    public var appDelegateType: UIApplicationDelegate.Type {
        let appDelegateType: UIApplicationDelegate.Type = isRunningTests ?
            TestAppDelegate.self :
            AppDelegate.self
        return appDelegateType
    }
}

/// App delegate for the unit tests
final class TestAppDelegate: UIResponder, UIApplicationDelegate {
}

private let delegateClassName = NSStringFromClass(ProcessInfo.processInfo.appDelegateType)
#else
private let delegateClassName = NSStringFromClass(AppDelegate.self)
#endif

_ = UIApplicationMain(
    argc,
    argv,
    principalClassName,
    delegateClassName
)
