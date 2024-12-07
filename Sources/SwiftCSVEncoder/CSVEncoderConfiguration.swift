//
//  File.swift
//  
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

/// A set of decisions about how to encode data for a given ``CSVTable``.
///
/// Currently this is covers strategies for encoding `Date` and `Bool` values.
public struct CSVEncoderConfiguration: Sendable {
    /// The strategy to use when encoding dates.
    ///
    /// The default strategy is the ``DateEncodingStrategy-swift.enum/iso8601`` strategy.
    public let dateEncodingStrategy: DateEncodingStrategy
    
    /// The strategy to use when encoding Boolean values.
    ///
    /// The default strategy is the ``BoolEncodingStrategy-swift.enum/trueFalse`` strategy.
    public let boolEncodingStrategy: BoolEncodingStrategy

    /// Creates a new instance of ``CSVEncoderConfiguration`` with the requisite configuration values
    /// - Parameter dateEncodingStrategy: The strategy to use when encoding dates
    /// - Parameter boolEncodingStrategy: The strategy to use when encoding Boolean values
    public init(
        dateEncodingStrategy: DateEncodingStrategy = .iso8601,
        boolEncodingStrategy: BoolEncodingStrategy = .trueFalse
    ) {
        self.dateEncodingStrategy = dateEncodingStrategy
        self.boolEncodingStrategy = boolEncodingStrategy
    }
    
    /// The strategy to use when encoding `Date` objects for CSV output.
    public enum DateEncodingStrategy: Sendable {
        /// The strategy that uses formatting from the `Date` structure.
        case deferredToDate
        /// The strategy that formats dates according to the ISO 8601 and RFC 3339 standards.
        case iso8601
        /// The strategy that defers formatting settings to a supplied date formatter.
        case formatted(DateFormatter)
        /// The strategy that formats custom dates by calling a user-defined function.
        /// - Parameter custom: A closure that receives the `Date` to encode, and returns the `String` to include in the CSV output.
        case custom(@Sendable (Date) -> String)
    }

    /// The strategy to use when encoding `Bool` objects for CSV output.
    public enum BoolEncodingStrategy: Sendable {
        /// The strategy that emits `true` and `false` for Boolean fields
        case trueFalse
        /// The strategy that emits `TRUE` and `FALSE` for Boolean fields
        case trueFalseUppercase
        /// The strategy that emite `yes` and `no` for Boolean fields
        case yesNo
        /// The strategy that emits `YES` and `NO` for Boolean fields
        case yesNoUppercase
        /// The strategy that emits `1` and `0` for Boolean fields
        case integer
        /// A custom strategy that emitss the custom supplied strings for Boolean fields
        case custom(true: String, false: String)
    }

    /// A default set of configuration values.
    ///
    /// This configuration set will be used when a ``CSVTable`` is initialized with setting a custom
    /// configuration.
    public static let `default`: CSVEncoderConfiguration = CSVEncoderConfiguration()
}

internal extension CSVEncoderConfiguration.BoolEncodingStrategy {
    var encodingValues: (String, String) {
        switch self {
        case .trueFalse:
            return ("true", "false")
        case .trueFalseUppercase:
            return ("TRUE", "FALSE")
        case .yesNo:
            return ("yes", "no")
        case .yesNoUppercase:
            return ("YES", "NO")
        case .integer:
            return ("1", "0")
        case .custom(let trueValue, let falseValue):
            return (trueValue, falseValue)
        }
    }
}
