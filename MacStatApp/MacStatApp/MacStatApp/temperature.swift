//
//  temperature.swift
//  MacStatApp
//
//  Created by alex haidar on 2/26/24.
//

import Foundation
import IOKit
import ObjectiveC



public class getTemperature {
    
    public struct SMCVal_t {
        var datasize: UInt32
        var datatype: UInt32
        var data: [UInt8]
    }
    
    @_silgen_name("openSMC")
    func openSMC() -> kern_return_t
    
    @_silgen_name("closeSMC")
    func closeSMC() -> kern_return_t
    
    @_silgen_name("readSMC")
    func readSMC(key: UnsafeMutablePointer<CChar>,val: UnsafeMutablePointer<SMCVal_t>) -> kern_return_t
    
    
    func convertAndPrintTempValue(key:UnsafePointer<CChar>?,scale: Character, showTemp: Bool ) -> kern_return_t {
        
        let openSM = openSMC()
        guard openSM == 0 else {
            print("Failed to open SMC: \(openSM)")
            return kern_return_t()
        }
        
        let closeSM = closeSMC()
        guard closeSM == 0 else {
            print("could not close SMC: \(closeSM)")
            return IOServiceClose(conn)
        }
        var smcVal = SMCVal_t( datasize: 0, datatype: 0 , data:[0])
        
        let array = smcKeys as! [String]              //Obj-c array converstion to swift array
        var convertedArray: [CChar] = []
        
        
        for str in array {
            if let charString = str.cString(using: .utf8) {        //converting all the smc keys from the 'smcKeys' array array to c style strings using utf8 encoding
                convertedArray.append(contentsOf: charString)
                
                
                
                var arrayPointer = UnsafeMutablePointer(mutating: convertedArray)
                let readSM = readSMC(key: arrayPointer, val: &smcVal )
            }
            
        }
            
            func convertAndPrint(val: SMCVal_t) -> Double {
                if val.datatype == (UInt32("f".utf8.first!) << 24 | UInt32("l".utf8.first!) << 16 | UInt32("t".utf8.first!) << 8)  {
                    let extractedTemp = Double(val.data[0])
                    return( extractedTemp * 9.0 / 5.0 + 32.0 )
                }
                return 0.0
            }
            
            let smcValue = SMCVal_t(datasize: 0, datatype: 0, data: [0])
            let convertedVal = convertAndPrint(val: smcValue)
            
            print("Temperarure:\(convertedVal)F°")
            
            return kern_return_t()
        }
        
    }
    


