//
//  SysRealTimeType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Real-Time MIDI Event types.
    public enum SysRealTimeType {
        /// System Real-Time: Timing Clock
        /// (MIDI 1.0 / 2.0)
        case timingClock
        
        /// System Real-Time: Start
        /// (MIDI 1.0 / 2.0)
        case start
        
        /// System Real-Time: Continue
        /// (MIDI 1.0 / 2.0)
        case `continue`
        
        /// System Real-Time: Stop
        /// (MIDI 1.0 / 2.0)
        case stop
        
        /// System Real-Time: Active Sensing
        /// (MIDI 1.0)
        case activeSensing
        
        /// System Real-Time: System Reset
        /// (MIDI 1.0 / 2.0)
        case systemReset
    }
}

extension MIDIEvent.SysRealTimeType: Equatable { }

extension MIDIEvent.SysRealTimeType: Hashable { }

extension MIDIEvent.SysRealTimeType: Identifiable {
    public var id: Self { self }
}

extension MIDIEvent.SysRealTimeType: Sendable { }

extension MIDIEvent {
    /// Declarative System Real-Time MIDI Event types used in event filters.
    public enum SysRealTimeTypes {
        /// Return only System Real-Time events.
        case only
        /// Return only System Real-Time events matching a certain event type.
        case onlyType(SysRealTimeType)
        /// Return only System Real-Time events matching certain event type(s).
        case onlyTypes(Set<SysRealTimeType>)
    
        /// Retain System Real-Time events only with a certain type,
        /// while retaining all non-System Real-Time events.
        case keepType(SysRealTimeType)
        /// Retain System Real-Time events only with certain type(s),
        /// while retaining all non-System Real-Time events.
        case keepTypes(Set<SysRealTimeType>)
    
        /// Drop all System Real-Time events,
        /// while retaining all non-System Real-Time events.
        case drop
        /// Drop all System Real-Time events,
        /// while retaining all non-System Real-Time events matching a certain event type.
        case dropType(SysRealTimeType)
        /// while retaining all non-System Real-Time events matching certain event type(s).
        case dropTypes(Set<SysRealTimeType>)
    }
}

extension MIDIEvent.SysRealTimeTypes: Equatable { }

extension MIDIEvent.SysRealTimeTypes: Hashable { }

extension MIDIEvent.SysRealTimeTypes: Sendable { }
