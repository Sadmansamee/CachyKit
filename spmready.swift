#!/usr/bin/swift

import Foundation

class Pod {
    init(name: String) {
        self.name = name
    }

    let name: String
    var repo: String?
    var spmready: Bool = false
}

extension Pod {
    func readyOrNot() -> String {
        if spmready {
            return "✅"
        }
        return "❌"
    }

    func format() -> String {
        "\(readyOrNot()) | \(name) : \(repo ?? "not found")"
    }
}

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> NSTextCheckingResult? {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range)
    }
}

func fetchPods(_ path: String) -> [Pod]? {
    var pods: [Pod] = []
    do {
        // Get the contents
        let contents = try String(contentsOfFile: path, encoding: .utf8)
        let lines = contents.split(separator: "\n")
        for line in lines {
            let regex = NSRegularExpression("pod '([A-Za-z0-9-]*)'")

            if let match = regex.matches(String(line)), let podNameRange = Range(match.range(at: 1), in: line) {
                let podName = line[podNameRange]
                pods.append(Pod(name: String(podName)))
            }
        }
        // sprint(contents)
    } catch {
        print("Failed to open Podfile at \(path)")
        print("make sure the file exists")
        return nil
    }
    return pods
}

func fetchUrl(pod: String) -> String {
    let semaphore = DispatchSemaphore(value: 0)

    let path = "https://cocoapods.org/pods/\(pod)"

    var result = ""

    guard let url = URL(string: path) else {
        return ""
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
        if let data = data {
            result = String(data: data, encoding: .utf8) ?? ""
        }

        semaphore.signal()
    }

    task.resume()

    _ = semaphore.wait(timeout: .distantFuture)
    return result
}

func isSpmReady(pod: Pod) -> Bool {
    guard let repo = pod.repo else {
        return false
    }

    let spmUrl = repo.replacingOccurrences(of: ".git", with: "") + "/blob/master/Package.swift"

    var result = false
    let semaphore = DispatchSemaphore(value: 0)
    let url = URL(string: spmUrl)!

    let task = URLSession.shared.dataTask(with: url) { _, response, _ in
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                result = true
            }
        }

        semaphore.signal()
    }

    task.resume()

    _ = semaphore.wait(timeout: .distantFuture)
    return result
}

func fetchRepoOnline(podName: String) -> String? {
    let page = fetchUrl(pod: podName)

    let regex = NSRegularExpression("(((https?):((//)|(\\\\))+[\\w\\d:#@%/;$()~_?\\+-=\\\\.&]*))\">GitHub Repo</a>")

    if let match = regex.matches(String(page)) {
        if let podNameRange = Range(match.range(at: 1), in: page) {
            let repo = page[podNameRange]
            return String(repo)
        }
    }

    return nil
}

let path: String

if CommandLine.arguments.count == 2 {
    path = CommandLine.arguments[1]
} else {
    let arg = CommandLine.arguments.first!

    path = arg.prefix(upTo: arg.lastIndex(of: "/")!) + "/Podfile"
}

// Set the file path

guard let pods = fetchPods(path) else {
    exit(1)
}

print("Found \(pods.count) pod")

for pod in pods {
    if let url = fetchRepoOnline(podName: pod.name) {
        pod.repo = url
        if isSpmReady(pod: pod) {
            pod.spmready = true
        }
        print(pod.format())
    }
}

let ready = pods.filter { $0.spmready }.count
let notReady = pods.filter { !$0.spmready }.count

if ready == pods.count {
    print("🎊 you are ready for Swift Package Manager")
} else {
    print("Sorry 😢 - ✅ \(ready) | ❌ \(notReady)")
    print("Help to improve SPM capablility by opening an issue or contribute via PR")
}
