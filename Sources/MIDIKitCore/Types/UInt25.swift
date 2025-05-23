//
//  UInt25.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import MIDIKitInternals

/// A 25-bit unsigned integer value type used in `MIDIKit`.
public struct UInt25: MIDIUnsignedInteger, _MIDIUnsignedInteger {
    public typealias Storage = UInt32
    @usableFromInline var storage: Storage
}

// MARK: - MIDIUnsignedInteger

extension UInt25 {
    @usableFromInline static let integerName: StaticString = "UInt25"
    
    @inline(__always)
    init(unchecked value: Storage) {
        storage = value
    }
}

// MARK: - Protocol Requirements

extension UInt25 {
    public typealias Magnitude = Storage.Magnitude
    public typealias Words = Storage.Words
    
    public static let bitWidth: Int = 25
}

// MARK: - Standard library extensions

extension BinaryInteger {
    /// Convenience initializer for `UInt25`.
    @inline(__always)
    public var toUInt25: UInt25 {
        UInt25(self)
    }
    
    /// Convenience initializer for `UInt25(exactly:)`.
    @inline(__always)
    public var toUInt25Exactly: UInt25? {
        UInt25(exactly: self)
    }
}

extension BinaryFloatingPoint {
    /// Convenience initializer for `UInt25`.
    @inline(__always)
    public var toUInt25: UInt25 {
        UInt25(self)
    }
    
    /// Convenience initializer for `UInt25(exactly:)`.
    @inline(__always)
    public var toUInt25Exactly: UInt25? {
        UInt25(exactly: self)
    }
}

// MARK: - Struct-Specific Properties

extension UInt25 {
    // 0b1_00000000_00000000_00000000
    /// Neutral midpoint.
    public static let midpoint = Self(Self.midpoint(as: Storage.self))
    static func midpoint<T: BinaryInteger>(as ofType: T.Type) -> T { 16_777_216 }
    
    /// Returns the integer as a `UInt32` instance
    @inline(__always)
    public var uInt32Value: UInt32 { storage }
}

// ----------------------------------------
// MARK: - Common Conformances Across UInts
// ----------------------------------------

// MARK: - Equatable

extension UInt25 /*: Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
}

// MARK: - Comparable

extension UInt25 /*: Comparable */ {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
}

// MARK: - Hashable

extension UInt25 /*: Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(storage)
    }
}

// MARK: - Sendable

extension UInt25: Sendable { }

// MARK: - Codable

extension UInt25 /*: Codable */ {
    public func encode(to encoder: Encoder) throws {
        var e = encoder.singleValueContainer()
        try e.encode(storage)
    }
    
    public init(from decoder: Decoder) throws {
        let d = try decoder.singleValueContainer()
        let decoded = try d.decode(Storage.self)
        guard let new = Self(exactly: decoded) else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Encoded value is not a valid \(Self.integerName)."
                )
            )
        }
        self = new
    }
}

// MARK: - CustomStringConvertible

extension UInt25 /* : CustomStringConvertible */ {
    public var description: String {
        storage.description
    }
}

extension UInt25 /* : CustomDebugStringConvertible */ {
    public var debugDescription: String {
        "\(Self.integerName)(\(storage.description))"
    }
}

// MARK: - _MIDIUnsignedInteger Default Implementation

extension UInt25 {
    static func min<T: BinaryInteger>(as ofType: T.Type) -> T { 0 }
    static func min<T: BinaryFloatingPoint>(as ofType: T.Type) -> T { 0 }
    
    static func max<T: BinaryInteger>(as ofType: T.Type) -> T {
        (0 ..< bitWidth)
            .reduce(into: T()) { $0 |= (0b1 << $1) }
    }
    
    static func max<T: BinaryFloatingPoint>(as ofType: T.Type) -> T {
        T(max(as: Int.self))
    }
}

// MARK: - MIDIUnsignedInteger Conveniences

extension UInt25 {
    /// Returns the integer converted to an `Int` instance (convenience).
    @inline(__always)
    public var intValue: Int { Int(storage) }
}

// MARK: - FixedWidthInteger

extension UInt25 /*: FixedWidthInteger */ {
    public static var min: Self { Self(Self.min(as: Storage.self)) }
    
    public static var max: Self { Self(Self.max(as: Storage.self)) }
    
    // this would be synthesized if MIDIUnsignedInteger conformed to FixedWidthInteger
    public static func >>= (lhs: inout Self, rhs: some BinaryInteger) {
        lhs.storage >>= rhs
    }
    
    // this would be synthesized if MIDIUnsignedInteger conformed to FixedWidthInteger
    public static func <<= (lhs: inout Self, rhs: some BinaryInteger) {
        lhs.storage <<= rhs
    }
}

// MARK: - Numeric

extension UInt25 /*: Numeric */ {
    // public typealias Magnitude = Storage.Magnitude
    // Magnitude is already expressed as same-type constraint on MIDIUnsignedInteger
    
    @inlinable
    public var magnitude: Storage.Magnitude {
        storage.magnitude
    }
    
    @inline(__always)
    public init?(exactly source: some BinaryInteger) {
        if source < Self.min(as: Storage.self) ||
            source > Self.max(as: Storage.self)
        {
            return nil
        }
        self.init(unchecked: Storage(source))
    }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage * rhs.storage)
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = Self(lhs.storage * rhs.storage)
    }
}

// MARK: - AdditiveArithmetic

extension UInt25 /*: AdditiveArithmetic */ {
    // static let zero synthesized by AdditiveArithmetic
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage + rhs.storage)
    }
    
    // += operator synthesized by AdditiveArithmetic
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage - rhs.storage)
    }
    
    // -= operator synthesized by AdditiveArithmetic
}

// MARK: - BinaryInteger

extension UInt25 /*: BinaryInteger */ {
    // public typealias Words = Storage.Words
    // Words is already expressed as same-type constraint on MIDIUnsignedInteger
    
    public var words: Storage.Words {
        storage.words
    }
    
    // synthesized?
    //    public static var isSigned: Bool { false }
    
    public var bitWidth: Int { Self.bitWidth }
    
    public var trailingZeroBitCount: Int {
        storage.trailingZeroBitCount - (storage.bitWidth - Self.bitWidth)
    }
    
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage / rhs.storage)
    }
    
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = Self(lhs.storage / rhs.storage)
    }
    
    public static func % (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage % rhs.storage)
    }
    
    public static func << (lhs: Self, rhs: some BinaryInteger) -> Self {
        Self(lhs.storage << rhs)
    }
    
    public static func >> (lhs: Self, rhs: some BinaryInteger) -> Self {
        Self(lhs.storage >> rhs)
    }
    
    public static func %= (lhs: inout Self, rhs: Self) {
        lhs.storage %= rhs.storage
    }
    
    public static func &= (lhs: inout Self, rhs: Self) {
        lhs.storage &= rhs.storage
    }
    
    public static func |= (lhs: inout Self, rhs: Self) {
        lhs.storage |= rhs.storage
    }
    
    public static func ^= (lhs: inout Self, rhs: Self) {
        lhs.storage ^= rhs.storage
    }
    
    public static prefix func ~ (x: Self) -> Self {
        // mask to bit width
        Self(unchecked: ~x.storage & Self.max(as: Self.self).storage)
    }
}
