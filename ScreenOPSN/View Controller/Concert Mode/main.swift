//
//  main.swift
//  ScreenOPSN
//
//  Created by Apple on 13/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

CommandLine.unsafeArgv.withMemoryRebound(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
{    argv in
    _ = UIApplicationMain(CommandLine.argc, argv, NSStringFromClass(InterractionUIApplication.self), NSStringFromClass(AppDelegate.self))
}
