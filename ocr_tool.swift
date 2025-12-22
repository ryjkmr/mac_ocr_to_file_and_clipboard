import Cocoa
import VisionKit

@MainActor
func runOCR() async {
    // 1. 範囲指定スクリーンショットの実行 (screencapture -i)
    let tempPath = "/tmp/ocr_capture.png"
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
    process.arguments = ["-i", tempPath]
    
    print("範囲を選択してください...")
    try? process.run()
    process.waitUntilExit()
    
    // ファイルが生成されたか確認
    guard FileManager.default.fileExists(atPath: tempPath),
          let image = NSImage(contentsOfFile: tempPath) else {
        print("キャンセルされたか、画像が取得できませんでした。")
        return
    }
    
    // 2. VisionKit (ImageAnalyzer) による解析
    // これが「ショートカット」や「テキスト認識」と同じエンジンです
    let analyzer = ImageAnalyzer()
    let configuration = ImageAnalyzer.Configuration([.text])
    
    print("解析中...")
    do {
        let analysis = try await analyzer.analyze(image, orientation: .up, configuration: configuration)
        let text = analysis.transcript
        
        if text.isEmpty {
            print("テキストは検出されませんでした。")
            return
        }
        
        print("--- 認識結果 ---")
        print(text)
        
        // 3. クリップボードにコピー
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        
        // 4. テキストファイルに追記

        // let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        // let entry = "\n--- \(timestamp) ---\n\(text)\n"
        let entry = "\n\(text)"

        let logFilePath = NSString(string: "~/Desktop/ocr_log.txt").expandingTildeInPath
        let logFileURL = URL(fileURLWithPath: logFilePath)
                
        if let data = entry.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logFilePath) {
                if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: logFileURL)
            }
        }
        
        print("\nクリップボードにコピーし、\(logFilePath) に追記しました。")
        
    } catch {
        print("エラーが発生しました: \(error)")
    }
    
    // 一時ファイルの削除
    try? FileManager.default.removeItem(atPath: tempPath)
}

// 実行
Task {
    await runOCR()
    exit(0)
}

// 実行ループの維持
RunLoop.main.run()
