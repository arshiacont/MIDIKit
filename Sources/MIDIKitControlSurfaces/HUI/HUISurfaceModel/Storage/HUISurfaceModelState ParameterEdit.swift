//
//  HUISurfaceModelState ParameterEdit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension HUISurfaceModelState {
    /// State storage representing the Parameter Edit section.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class ParameterEdit {
        public var assign = false
        public var compare = false
        public var bypass = false
        
        public var param1Select = false
        
        /// Parameter 1 V-Pot Display LEDs.
        public var param1VPotDisplay: HUIVPotDisplay = .init()
        
        public var param2Select = false
        
        /// Parameter 2 V-Pot Display LEDs.
        public var param2VPotDisplay: HUIVPotDisplay = .init()
        
        public var param3Select = false
        
        /// Parameter 3 V-Pot Display LEDs.
        public var param3VPotDisplay: HUIVPotDisplay = .init()
        
        public var param4Select = false
        
        /// Parameter 4 V-Pot Display LEDs.
        public var param4VPotDisplay: HUIVPotDisplay = .init()
        
        /// Toggle: Insert (off) / Param (on)
        public var insertOrParam = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.ParameterEdit: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.ParameterEdit
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .assign:        assign
        case .compare:       compare
        case .bypass:        bypass
        case .param1Select:  param1Select
        case .param2Select:  param2Select
        case .param3Select:  param3Select
        case .param4Select:  param4Select
        case .insertOrParam: insertOrParam
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .assign:        assign = state
        case .compare:       compare = state
        case .bypass:        bypass = state
        case .param1Select:  param1Select = state
        case .param2Select:  param2Select = state
        case .param3Select:  param3Select = state
        case .param4Select:  param4Select = state
        case .insertOrParam: insertOrParam = state
        }
    }
}
