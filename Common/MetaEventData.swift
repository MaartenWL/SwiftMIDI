//
//  MetaEventData.swift
//  SwiftMIDIAPIExtensions
//
//  Created by Jan Ratschko on 24.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import AudioToolbox

extension UnsafePointer where Pointee == MIDIMetaEvent {
    var data:UnsafeBufferPointer<UInt8> {
        // access pointer to const UInt8 form const packet pointer
        // this is done with a c-function, MIDIMetaEventGetData, not possible in swift
        return UnsafeBufferPointer<UInt8>(start:MIDIMetaEventGetData(self), count:Int(self.pointee.dataLength))
    }
}

extension HeadedBytes where HeaderType == MIDIMetaEvent {
    init(metaEventType type:UInt8 ,data: Data) {
        self.init(numTrailingBytes: data.count) { metaEvent in
            metaEvent.pointee.metaEventType = type
            metaEvent.pointee.dataLength = UInt32(data.count)
            
            _ = data.withUnsafeBytes { bytes in
                memcpy(&metaEvent.pointee.data, bytes, data.count)
            }
        }
    }
}
