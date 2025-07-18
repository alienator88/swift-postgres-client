//
//  PostgresByteATest.swift
//  PostgresClientKit
//
//  Copyright 2019 David Pitfield and the PostgresClientKit contributors
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SwiftPostgresClient
import Testing
import Foundation

/// Tests PostgresByteA.
struct PostgresByteATest {
    
    @Test func test() {
        
        let data = Data([ 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef,
                          0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef ])

        let hexEncodedLowercase = "\\xdeadbeefdeadbeef0123456789abcdef"
        let hexEncodedUppercase = "\\xDEADBEEFDEADBEEF0123456789ABCDEF"

        // Test init(data:).
        let byteA = PostgresByteA(data: data)
        #expect(byteA == byteA)
        #expect(byteA.data == data)
        #expect(byteA.postgresValue.rawValue == hexEncodedLowercase)
        #expect(byteA.description == "PostgresByteA(count=\(data.count))")
        
        // Test init(_:) lowercase.
        var byteA2 = PostgresByteA(hexEncodedLowercase)!
        #expect(byteA2 == byteA)
        #expect(byteA2.data == data)
        #expect(byteA2.postgresValue.rawValue == hexEncodedLowercase)
        #expect(byteA2.description == "PostgresByteA(count=\(data.count))")
        
        // Test init(_:) uppercase.
        byteA2 = PostgresByteA(hexEncodedUppercase)!
        #expect(byteA2 == byteA)
        #expect(byteA2.data == data)
        #expect(byteA2.postgresValue.rawValue == hexEncodedLowercase)
        #expect(byteA2.description == "PostgresByteA(count=\(data.count))")
        
        // Test init(data:) 0-length.
        byteA2 = PostgresByteA(data: Data())
        #expect(byteA2 != byteA)
        #expect(byteA2.data == Data())
        #expect(byteA2.postgresValue.rawValue == "\\x")
        #expect(byteA2.description == "PostgresByteA(count=0)")
        
        // Test init(_:) 0-length.
        byteA2 = PostgresByteA("\\x")!
        #expect(byteA2 != byteA)
        #expect(byteA2.data == Data())
        #expect(byteA2.postgresValue.rawValue == "\\x")
        #expect(byteA2.description == "PostgresByteA(count=0)")

        // Test init(_:) invalid (missing prefix).
        #expect(PostgresByteA("foo") == nil)

        // Test init(_:) invalid (invalid length).
        #expect(PostgresByteA("\\x123") == nil)
        
        // Test init(_:) invalid (invalid character).
        #expect(PostgresByteA("\\x123xyz") == nil)
    }
}
