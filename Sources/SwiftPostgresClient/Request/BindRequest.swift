//
//  BindRequest.swift
//  PostgresClientKit
//
//  Copyright 2019 David Pitfield and the PostgresClientKit contributors
//  Copyright 2025 Will Temperley and the SwiftPostgresClient contributors
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

import Foundation

struct BindRequest: Request {
    
    private let name: String
    private let statement: Statement
    private let parameterValues: [PostgresValueConvertible?]
    
    init(name: String, statement: Statement, parameterValues: [PostgresValueConvertible?]) {
        self.name = name
        self.statement = statement
        self.parameterValues = parameterValues
    }

    var requestType: Character? {
        return "B"
    }
    
    var body: Data {
        
        var body = name.dataZero                          // destination portal
        body.append(statement.name.dataZero)              // statement name
        body.append(UInt16(0).data)                     // use default parameter format ("text")
        body.append(UInt16(parameterValues.count).data) // number of parameter values
        
        for parameterValue in parameterValues {
            if let rawValue = parameterValue?.postgresValue.rawValue {
                let rawValueBytes = rawValue.data
                body.append(UInt32(rawValueBytes.count).data)
                body.append(rawValueBytes)
            } else {
                body.append(UInt32.max.data)            // indicates SQL NULL
            }
        }
        
        body.append(UInt16(0).data)                     // use default result column format ("text")
        
        return body
    }
}
