//
//  ReduxTests.swift
//  ReduxTests
//
//  Created by Jonathan Cravotta on 3/26/18.
//  Copyright © 2018 Jonathan Cravotta. All rights reserved.
//

import XCTest

class ReduxTests: XCTestCase {
    
    var userStore: UserStore!
    
    var userValue: User {
        return userStore.state.value
    }
    
    override func setUp() {
        super.setUp()
        
        let stubUser = User(name: "Fashy", zipcode: 10014, sizes: [0,2])
        self.userStore = UserStore(user: stubUser)
    }
    
    func testNameAction() {
        userStore.dispatch(action: .updateName("Fashinator"))
        XCTAssertTrue(userValue.name == "Fashinator", "Names should match")
    }
    
    func testZipAction() {
        userStore.dispatch(action: .updateZip(10021))
        XCTAssertTrue(userValue.zipcode == 10021, "Zip should match")
    }
    
    func testSizeAction() {
        userStore.dispatch(action: .updateSizes([4,5]))
        
        let sizes = userValue.sizes
        XCTAssertTrue((sizes[0] == 4 && sizes[1] == 5), "Sizes should match")
    }
    
    func testZipAndSizeAction() {
        userStore.dispatch(action: .updateZipAndSizes(zip: 10013, sizes: [6,8]))
        XCTAssertTrue(userValue.zipcode == 10013, "Zip should match")
        XCTAssertTrue((userValue.sizes[0] == 6 && userValue.sizes[1] == 8), "Sizes should match")
    }
}
