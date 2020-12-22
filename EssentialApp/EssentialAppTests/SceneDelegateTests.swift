//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Khoi Nguyen on 22/12/20.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {

    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        
        sut.window = UIWindow()
        sut.configureWindow()
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topViewController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topViewController is FeedViewController, "Expected a feed view controller as top view controller, got \(String(describing: topViewController)) instead")
    }

}
