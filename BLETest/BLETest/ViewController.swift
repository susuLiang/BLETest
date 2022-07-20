//
//  ViewController.swift
//  BLETest
//
//  Created by Susu on 2022/7/19.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

}

extension ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("poweredOff")
            //停止掃描
            self.centralManager.stopScan()
            
        case .poweredOn:
            print("poweredOn")
            //開始掃描
            self.centralManager.scanForPeripherals(withServices: [BLEPeripheral.serviceUUID],
                                                   options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])

        case .resetting, .unauthorized, .unknown, .unsupported:
            break
        @unknown default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        self.centralManager.stopScan()
        self.peripheral.delegate = self
        self.centralManager.connect(self.peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected")
            peripheral.discoverServices([BLEPeripheral.serviceUUID])
        }
    }
}


