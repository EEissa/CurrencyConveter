
import Foundation
import ObjectMapper

@dynamicMemberLookup
enum DynamicResponse {
    // MARK: Cases
    case dictionary(Dictionary<String, DynamicResponse>)
    case array(Array<DynamicResponse>)
    case string(String)
    case number(NSNumber)
    case bool(Bool)
    case null

    // MARK: Dynamic Member Lookup
    
    public subscript(dynamicMember member: String) -> DynamicResponse {
        if case .dictionary(let dict) = self {
            return dict[member] ?? .null
        }
        return .null
    }
    
    // MARK: Subscript
    
    public subscript(index: Int) -> DynamicResponse {
        if case .array(let arr) = self {
            return index < arr.count ? arr[index] : .null
        }
        return .null
    }
    
    public subscript(key: String) -> DynamicResponse {
        if case .dictionary(let dict) = self {
            return dict[key] ?? .null
        }
        return .null
    }

    public subscript(keys: [Nested]) -> DynamicResponse {
        var temp = self
        for key in keys {
            switch key {
            case .key(let string):
                temp = temp[string]
            case .index(let index):
                temp = temp[index]
            }
        }
        return temp
    }

    // MARK: Initializers
    
    public init(data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: options)
        self = DynamicResponse(object)
    }
    
    public init(_ object: Any?) {
        if let data = object as? Data, let converted = try? DynamicResponse(data: data) {
            self = converted
        } else if let dictionary = object as? [String: Any] {
            self = DynamicResponse.dictionary(dictionary.mapValues { DynamicResponse($0) })
        } else if let array = object as? [Any] {
            self = DynamicResponse.array(array.map { DynamicResponse($0) })
        } else if let string = object as? String {
            self = DynamicResponse.string(string)
        } else if let number = object as? NSNumber {
            self = DynamicResponse.number(number)
        } else if let bool = object as? Bool {
            self = DynamicResponse.bool(bool)
        } else {
            self = DynamicResponse.null
        }
    }
    
    // MARK: Accessors
    
    public var dictionary: Dictionary<String, DynamicResponse>? {
        if case .dictionary(let value) = self {
            return value
        }
        return nil
    }
    
    public var array: Array<DynamicResponse>? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
    
    public var string: String? {
        if case .string(let value) = self {
            return value
        } else if case .bool(let value) = self {
            return value ? "true" : "false"
        } else if case .number(let value) = self {
            return value.stringValue
        }
        return nil
    }
    
    public var number: NSNumber? {
        if case .number(let value) = self {
            return value
        } else if case .bool(let value) = self {
            return NSNumber(value: value)
        } else if case .string(let value) = self, let doubleValue = Double(value) {
            return NSNumber(value: doubleValue)
        }
        return nil
    }
    
    public var double: Double? {
        return number?.doubleValue
    }
    
    public var int: Int? {
        return number?.intValue
    }
    
    public var bool: Bool? {
        if case .bool(let value) = self {
            return value
        } else if case .number(let value) = self {
            return value.boolValue
        } else if case .string(let value) = self,
            (["true", "t", "yes", "y", "1"].contains { value.caseInsensitiveCompare($0) == .orderedSame }) {
            return true
        } else if case .string(let value) = self,
            (["false", "f", "no", "n", "0"].contains { value.caseInsensitiveCompare($0) == .orderedSame }) {
            return false
        }
        return nil
    }
    
    // MARK: Helpers
    
    public var object: Any {
        get {
            switch self {
            case .dictionary(let value): return value.mapValues { $0.object }
            case .array(let value): return value.map { $0.object }
            case .string(let value): return value
            case .number(let value): return value
            case .bool(let value): return value
            case .null: return NSNull()
            }
        }
    }
    
    public func data(options: JSONSerialization.WritingOptions = []) -> Data {
        return (try? JSONSerialization.data(withJSONObject: self.object, options: options)) ?? Data()
    }
    
}

// MARK: - Comparable

extension DynamicResponse: Comparable {
    
    public static func == (lhs: DynamicResponse, rhs: DynamicResponse) -> Bool {
        switch (lhs, rhs) {
        case (.dictionary, .dictionary): return lhs.dictionary == rhs.dictionary
        case (.array, .array): return lhs.array == rhs.array
        case (.string, .string): return lhs.string == rhs.string
        case (.number, .number): return lhs.number == rhs.number
        case (.bool, .bool): return lhs.bool == rhs.bool
        case (.null, .null): return true
        default: return false
        }
    }
    
    public static func < (lhs: DynamicResponse, rhs: DynamicResponse) -> Bool {
        switch (lhs, rhs) {
        case (.string, .string):
            if let lhsString = lhs.string, let rhsString = rhs.string {
                return lhsString < rhsString
            }
            return false
        case (.number, .number):
            if let lhsNumber = lhs.number, let rhsNumber = rhs.number {
                return lhsNumber.doubleValue < rhsNumber.doubleValue
            }
            return false
        default: return false
        }
    }
}

// MARK: - ExpressibleByLiteral

extension DynamicResponse: Swift.ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        let dictionary = elements.reduce(into: [String: Any](), { $0[$1.0] = $1.1})
        self.init(dictionary)
    }
}

extension DynamicResponse: Swift.ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Any...) {
        self.init(elements)
    }
}

extension DynamicResponse: Swift.ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension DynamicResponse: Swift.ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

extension DynamicResponse: Swift.ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension DynamicResponse: Swift.ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

// MARK: - Pretty Print

extension DynamicResponse: Swift.CustomStringConvertible, Swift.CustomDebugStringConvertible {
    
    public var description: String {
        return String(describing: self.object as AnyObject).replacingOccurrences(of: ";\n", with: "\n")
    }
    
    public var debugDescription: String {
        return description
    }
}
enum Nested {
    case key(_ key: String)
    case index(_ index: Int)
}
