//
//  main.swift
//  No rights reserved.
//

import Foundation

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
    
    var rules = [(Int, Int)]()
    var updates = [[Int]]()
    
    var parsingRules = true
    lines.forEach { line in
        if line.isEmpty {
            parsingRules = false
        } else {
            if parsingRules {
                let rule = parseRule(from: line)
                rules.append(rule)
            } else {
                updates.append(parseUpdate(from: line))
            }
        }
    }

    let correctUpdates = updates.filter { update in
        for i in 0..<update.count {
            let number = update[i]
            let applicableRules = rules.filter { $0.0 == number }
            if !applicableRules.isEmpty {
                for rule in applicableRules {
                    let number2 = rule.1
                    if let updateIndex = update.firstIndex { $0 == number2 } {
                        if i > updateIndex {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    let mids = correctUpdates.reduce(into: []) { partialResult, update in
        partialResult.append(update[(update.count-1)/2])
    }
    
    print(mids.reduce(0, +))
}

func parseRule(from line: String) -> (Int, Int) {
    let comp = line.components(separatedBy: "|").map { Int($0)! }
    return (comp[0], comp[1])
}

func parseUpdate(from line: String) -> [Int] {
    let comp = line.components(separatedBy: ",")
    return comp.map { Int($0)! }
}

main()
