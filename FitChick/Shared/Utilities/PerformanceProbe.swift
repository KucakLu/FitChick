import Foundation
import os.signpost

enum PerformanceProbe {
    nonisolated private static let log = OSLog(subsystem: "FitChick", category: "Performance")

    nonisolated static func event(_ name: StaticString) {
        os_signpost(.event, log: log, name: name)
    }

    nonisolated static func measure<T>(_ name: StaticString, _ operation: () throws -> T) rethrows -> T {
        let signpostID = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: name, signpostID: signpostID)
        defer {
            os_signpost(.end, log: log, name: name, signpostID: signpostID)
        }

        return try operation()
    }

    nonisolated static func measure<T>(
        _ name: StaticString,
        _ operation: () async throws -> T
    ) async rethrows -> T {
        let signpostID = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: name, signpostID: signpostID)
        defer {
            os_signpost(.end, log: log, name: name, signpostID: signpostID)
        }

        return try await operation()
    }
}
