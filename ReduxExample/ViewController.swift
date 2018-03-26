//
//  ViewController.swift
//  ReduxExample
//
//  Created by Jonathan Cravotta on 3/24/18.
//  Copyright © 2018 Jonathan Cravotta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let t = UserExample()
        t.test()
    }
}

class UserExample {
    
    let userStore: UserStore
    
    init() {
        let user = User(name: "Foo", zipcode: 10021, sizes: [4, 5])
        self.userStore = UserStore(user: user)
        observe()
    }
    
    func test() {
        userStore.dispatch(action: .updateName("Baz"))
        userStore.dispatch(action: .updateSizes([0, 2]))
        userStore.dispatch(action: .updateZip(10014))
        userStore.dispatch(action: .updateZipAndSizes(zip: 10013, sizes: [4,5,6,8]))
    }
    
    func observe() {
        userStore.state.observeProducer { (user) in
            print("Name: \(user.name), Zip: \(user.zipcode), Sizes: \(user.sizes.map { $0 })")
        }
    }
}
