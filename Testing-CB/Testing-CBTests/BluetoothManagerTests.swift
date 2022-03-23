//
//  BluetoothManagerTests.swift
//  Testing-CBTests
//
//  Created by Islom Babaev on 23/03/22.
//

import XCTest
import CoreBluetooth

final class BluetoothManager: NSObject {
    
    private(set) var centralManager = CBCentralManager()
    
    var didUpdateState : (() -> Void)?
    private var scanCompletion: ((CBPeripheral) -> Void)?
    
    override init() {
        super.init()
        centralManager.delegate = self
    }
    
    func scan(completion: @escaping (CBPeripheral) -> Void) {
        scanCompletion = completion
    }
}

extension BluetoothManager : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        didUpdateState?()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        scanCompletion?(peripheral)
    }
}
    


final class BluetoothManagerTests : XCTestCase {
    
    func test_init_setsManagerAsDelegateOfCentralManager() {
        let sut = BluetoothManager()
        
        XCTAssertNotNil(sut.centralManager.delegate)
    }
    
    func test_init_triggersDidUpdateStateDelegateMethod() {
        let sut = BluetoothManager()
        
        var callCount = 0
        sut.didUpdateState = { callCount += 1 }
        
        sut.centralManager.delegate?.centralManagerDidUpdateState(sut.centralManager)
        
        XCTAssertEqual(callCount, 1)
    
    }
    
    func test_scan_discoversPeripheral() {
        let sut = BluetoothManager()
        guard let expectedPeripheral = Creator.create("CBPeripheral") as? CBPeripheral else {
            XCTFail("Expected to create an instance of CBPeripheral")
            return
        }
        expectedPeripheral.addObserver(expectedPeripheral, forKeyPath: "delegate", options: .new, context: nil)
        let exp = expectation(description: "wait for scan completion")
        
        sut.scan { peripheral in
            XCTAssertEqual(peripheral, expectedPeripheral)
            exp.fulfill()
        }
        sut.centralManager.delegate?.centralManager?(sut.centralManager, didDiscover: expectedPeripheral, advertisementData: [:], rssi: NSNumber())
        
        wait(for: [exp], timeout: 0.1)
    }
   
}



//
//func test() {
//    let sut = BluetoothManager()
//
//    sut.scanForDevices { device in }
//
//    sut.centralManager.delegate?.centralManager?(<#T##central: CBCentralManager##CBCentralManager#>, didDiscover: <#T##CBPeripheral#>, advertisementData: <#T##[String : Any]#>, rssi: <#T##NSNumber#>)
//}
