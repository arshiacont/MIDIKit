//
//  MIDIManager addInputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

extension MIDIManager {
    /// Creates a new managed input connection in the system and adds it to the ``MIDIManager/managedInputConnections``
    /// dictionary of the ``MIDIManager``.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI
    /// events. It can also be instanced without providing any initial inputs and then inputs can be
    /// added or removed later.
    ///
    /// - Parameters:
    ///   - outputs: Criteria for identifying target MIDI endpoint(s). These may be added or
    ///     removed later.
    ///   - tag: Internal unique tag to reference the managed item in the ``MIDIManager``.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to
    ///     the connection.
    ///   - receiver: Receive handler to use for incoming MIDI messages.
    ///
    /// - Throws: ``MIDIIOError``
    public func addInputConnection(
        to outputs: MIDIInputConnectionMode,
        tag: String,
        filter: MIDIEndpointFilter = .default(),
        receiver: MIDIReceiver
    ) throws {
        try managementQueue.sync {
            let newCD = MIDIInputConnection(
                mode: outputs,
                filter: filter,
                receiver: receiver,
                midiManager: self,
                api: preferredAPI
            )
            
            // store the connection object in the manager,
            // even if subsequent connection fails
            managedInputConnections[tag] = newCD
            
            try newCD.listen(in: self)
            try newCD.connect(in: self)
        }
    }
}

#endif
