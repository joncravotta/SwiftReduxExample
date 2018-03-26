//
//  ViewController.swift
//  ReduxExample
//
//  Created by Jonathan Cravotta on 3/24/18.
//  Copyright © 2018 Jonathan Cravotta. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let t = UserExample()
        t.test()
    }
}

final class UserExample {
    
    init() {
        observe()
    }
    
    func test() {
        store.dispatch(UserName(name: "Baz"))
        store.dispatch(UserSizes(sizes: [0, 2]))
        store.dispatch(UserZipCode(zipcode: 10014))
        store.dispatch(UserZipCodeAndSizes(zipcode: 10013, sizes: [4,5,6,8]))
        store.dispatch(ToggleDarkTheme(enable: true))
    }
    
    func observe() {
        store.observeProducer(keyPath: \.user) { user in
            print("Name: \(user.name), Zip: \(user.zipcode), Sizes: \(user.sizes.map { $0 })")
        }

        store.observeProducer(keyPath: \.appConfiguration) { appConfiguration in
            print("Push Notifications enabled: \(appConfiguration.arePushNotificationsEnabled), Dark Theme: \(appConfiguration.isDarkThemed)")
        }
    }
}
