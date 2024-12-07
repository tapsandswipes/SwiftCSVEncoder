//
//  CSVColumn.swift
//  
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

/// The definition of a single column within a ``CSVTable``.
///
/// Each column has a ``header`` which is output in the first row of the output CSV text file, and an ``attribute`` method which returns the data for that column.
public struct CSVColumn<Record> {
    /// The header name to use for the column in the CSV file's first row.
    public let header: String
    
    /// How to derive the column's contents for the given record.
    ///
    /// This closure must return a value which conforms to ``CSVEncodable``.
    public let attribute: (Record) -> CSVEncodable
    
    /// Create a definition for a given column in a ``CSVTable``.
    ///
    /// Columns are typed to a specific data type, for example:
    ///
    /// ```swift
    /// let firstNameColumn: CSVColumn<Person> = CSVColumn("First Name", attribute: { person in person.firstName })
    /// ```
    ///
    /// Definitions may use standard Swift shorthand syntax including trailing closures and anonymous attributes:
    ///
    /// ```swift
    /// let lastNameColumn: CSVColumn<Person> = CSVColumn("Last Name") { $0.lastName }
    /// ```
    ///
    /// The primary use of columns is in ``CSVTable`` initialization and will often be defined inline in
    /// ``CSVTable/init(columns:configuration:)``.
    ///
    /// - Parameters:
    ///   - header: The header name to use in the CSV file's first row.
    ///   - attribute: A function that returns the value for that column, given the record representing a data row.
    public init(
        _ header: String,
        attribute: @escaping (Record) -> CSVEncodable
    ) {
        self.header = header
        self.attribute = attribute
    }
}

extension CSVColumn {
    /// Create a definition for a given column in a ``CSVTable`` from an encodable property.
    ///
    /// Columns are typed to a specific data type, for example:
    ///
    /// ```swift
    /// let firstNameColumn: CSVColumn<Person> = CSVColumn("First Name", \.firstName)
    /// ```
    ///
    /// If you need to encapsulate any other sort of work – for example, converting a customer property into a value
    /// that conforms to ``CSVEncodable`` - you can use the ``init(_:attribute:)`` initializer.
    ///
    /// The primary use of columns is in ``CSVTable`` initialization and will often be defined inline in
    /// ``CSVTable/init(columns:configuration:)``.
    ///
    /// - Parameters:
    ///   - header: The header name to use in the CSV file's first row.
    ///   - keyPath: A key path to the attribute to use as a row's value for that column. This must point to a property
    ///     whose data type conforms to ``CSVEncodable``
    public init<T: CSVEncodable> (
        _ header: String,
        _ keyPath: KeyPath<Record, T>
    ) {
        self.init(
            header,
            attribute: { $0[keyPath: keyPath] }
        )
    }
}
