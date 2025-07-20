//
//  File.swift
//  ClubDonorsPackage
//
//  Created by Yassin El Mouden on 20/12/2024.
//

import ConcurrencyExtras
import Foundation
import SwiftyBeaver
import Utils
import UIKit

public final class AppLogger {
    // MARK: Properties

    public static let initDate = LockIsolated<Date>(Date())
    private static let ttaLogged = LockIsolated<Bool>(false)

    // MARK: - Configuration

    public static func configure() {
        addFileDestination()
    }

    private static func addConsoleDestination() {
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l :: $M"
        SwiftyBeaver.addDestination(console)
    }

    private static func addFileDestination() {
        let file = FileDestination()
        let url = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: true)
        let fileURL = url?.appendingPathComponent("debug.log")
        file.logFileURL = fileURL

        file.format = "$Dy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l :: $M"
        file.minLevel = .info
        file.asynchronously = false

        SwiftyBeaver.addDestination(file)

        let logPath = fileURL?.absoluteString.replacingOccurrences(of: "file://", with: "") ?? ""
        print("==================================")
        print("To get logs:")
        print("tail -f \(logPath)")
        print("==================================")
    }

    // MARK: - Logging

    @MainActor
    public static func infoAppStarted(_ file: String = #file,
                               _ function: String = #function,
                               line: Int = #line) {
        SwiftyBeaver.info("====================", file: file, function: function, line: line)
        SwiftyBeaver.info("Application Started", file: file, function: function, line: line)
        SwiftyBeaver.info(UIDevice.current.name, file: file, function: function, line: line)
        SwiftyBeaver.info("====================", file: file, function: function, line: line)
    }

    public static func timeToAction(_ file: String = #file,
                             _ function: String = #function,
                             line: Int = #line) {
        guard let emoji = emojiForLog((function)), ttaLogged.value == false else { return }

        let millisecondsElapsed = Int(Date().timeIntervalSince1970 * 1_000) - Int(initDate.value.timeIntervalSince1970 * 1_000)
        let ttaContent = "\(emoji) TTA: \(millisecondsElapsed)ms"
        if millisecondsElapsed > 3_000 {
            SwiftyBeaver.warning(ttaContent, file: file, function: function, line: line, context: nil)
            //remoteLogger.log(type: .warning, content: ttaContent)
        } else {
            SwiftyBeaver.info(ttaContent, file: file, function: function, line: line, context: nil)
            //remoteLogger.log(type: .info, content: ttaContent)
        }
        ttaLogged.withValue{
            $0 = true
        }
    }

    public static func info(_ message: @autoclosure () -> Any,
                     _ file: String = #file,
                     _ function: String = #function,
                     line: Int = #line) {
        if let emoji = emojiForLog((function)), let message = message() as? String {
            SwiftyBeaver.info(emoji + " " + message, file: file, function: function, line: line, context: nil)
        }
    }

    public static func warning(_ message: @autoclosure () -> Any,
                        _ file: String = #file,
                        _ function: String = #function,
                        line: Int = #line) {
        if let emoji = emojiForLog((function)), let message = message() as? String {
            let content = emoji + " " + message
            SwiftyBeaver.warning(content.warningColor, file: file, function: function, line: line, context: nil)
            //remote(.warning, content)
        }
    }

    public static func error(
                      _ message: @autoclosure () -> Any,
                      _ file: String = #file,
                      _ function: String = #function,
                      line: Int = #line) {
        if let emoji = emojiForLog((function)), let message = message() as? String {
            let content = emoji + " " + message
            SwiftyBeaver.error(content.errorColor, file: file, function: function, line: line, context: nil)

            //remoteError(type, additionalInfos: ["message": content])
        }
    }

    public static func critical(
                      _ message: @autoclosure () -> Any,
                      _ file: String = #file,
                      _ function: String = #function,
                      line: Int = #line) {
        if let emoji = emojiForLog((function)), let message = message() as? String {
            let content = emoji + " " + message
            SwiftyBeaver.critical(content.errorColor, file: file, function: function, line: line, context: nil)

            //remoteError(type, additionalInfos: ["message": content])
        }
    }

    // MARK: - Private

    private static func emojiForLog(_ function: String = #file) -> String? {
        // swiftlint:disable:next line_length
        let logEmojis = ["😀", "😎", "😱", "😈", "👺", "👽", "👾", "🤖", "🎃", "👍", "👁", "🧠", "🎒", "🧤", "🐶", "🐱", "🐭", "🐹", "🦊", "🐻", "🐨", "🐵", "🦄", "🦋", "🌈", "🔥", "💥", "⭐️", "🍉", "🥝", "🌽", "🍔", "🍿", "🎹", "🎁", "🔔", "👑", "🥤", "🍣", "🧬", "💎", "🔮"]
        return logEmojis[safe: abs(function.fixedHash % logEmojis.count)]
    }

}

public extension String {
    var errorColor: String { Array(self).map { "\($0)\u{fe06}" }.joined() }
    var successColor: String { Array(self).map { "\($0)\u{fe07}" } .joined() }
    var warningColor: String { Array(self).map { "\($0)\u{fe08}" }.joined() }
}

