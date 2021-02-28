//
//  AppDelegate.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/27.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  let appDIContainer = AppDIContainer()
  var appFlowCoordinator: AppFlowCoordinator?

  private let bag = DisposeBag()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    window = UIWindow(frame: UIScreen.main.bounds)

    appFlowCoordinator = AppFlowCoordinator(window: window, appDIContainer: appDIContainer)

    appFlowCoordinator?
      .start()
      .subscribe()
      .disposed(by: bag)

    return true
  }

}

