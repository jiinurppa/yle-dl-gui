//
//  ContentView.swift
//  yle-dl-gui
//
//  Created by Juuso Nurminen on 31.1.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var url: String = ""
    @State private var filename: String = ""
    @State private var downloadPath: String = ""
    @State private var format: Int = 0
    @State private var downloading: Bool = false
    @State private var downloadResult: String = ""
    @State private var downloadedFilePath: String = ""
    
    private let helpUrl: URL = URL(string: "https://github.com/aajanki/yle-dl/blob/master/OS-install-instructions.md#mac-os-x")!
    private let pathVar: String = "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin"
    private let yleDlPath: String = "/opt/homebrew/bin/yle-dl"
    private let filenameExtension: String = ".mp4"
    
    init() {
        _downloadPath = State(initialValue: defaultPath())
        
        if (!FileManager.default.fileExists(atPath: yleDlPath))
        {
            _downloadResult = State(initialValue: "yleDlNotInstalledWarning".localized)
        }
    }
    
    func defaultPath() -> String {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let downloadPath = paths[0].path
        return downloadPath
    }
    
    func openFileInFinder(path: String, filename: String) {
        let file = [URL(fileURLWithPath: path).appendingPathComponent(filename)];
        NSWorkspace.shared.activateFileViewerSelecting(file);
    }
    
    func filenameTimestamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm_dd.MM.y"
        return dateFormatter.string(from: date)
    }
    
    func downloadFile() {
        downloading = true
        downloadResult = ""
        downloadedFilePath = ""
        filename = "filenamePrefix".localized + filenameTimestamp() + filenameExtension
        let command = "export PATH=\(pathVar); yle-dl -qq -o \(filename) --destdir \(downloadPath) \(url)"
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", command]
        process.launch()
        process.waitUntilExit()
        let result = process.terminationStatus
        
        if result == 0 {
            downloading = false
            downloadResult = "downloadSucceeded".localized;
            downloadedFilePath = downloadPath
        }
        else {
            downloading = false
            downloadResult = "downloadFailed".localized
        }
    }
    
    var body: some View {
        VStack {
            // --- Video address ---
            HStack() {
                Text("videoUrlButton".localized)
                TextField("eg".localized + " " + "https://areena.yle.fi/1-50627943", text: $url)
            }.padding(.horizontal)
            // --- File path ---
            HStack {
                Text("pathButton".localized)
                TextField("eg".localized + " " + defaultPath(), text: $downloadPath)
                Button("browse".localized) {
                    let fileDialog = NSOpenPanel()
                    fileDialog.prompt = "chooseFolder".localized
                    fileDialog.canChooseDirectories = true
                    fileDialog.canChooseFiles = false
                    fileDialog.worksWhenModal = true
                    fileDialog.begin { (result) in
                        if result == NSApplication.ModalResponse.OK {
                            downloadPath = fileDialog.url?.path ?? ""
                        }
                    }
                }
            }.padding(.horizontal)
            HStack {
                Text(downloadResult).padding(.leading)
                
                if downloadResult == "yleDlNotInstalledWarning".localized {
                    Link("yleDlHelpLink".localized, destination: helpUrl)
                }
                
                // --- Show file ---
                if !downloadedFilePath.isEmpty {
                    Button("showVideoButton".localized) {
                        openFileInFinder(path: downloadedFilePath, filename: filename)
                    }.padding(.leading)
                }
                
                Spacer()
                // --- Download ---
                Button("download".localized) {
                    downloadFile()
                }
                .disabled(url.isEmpty || downloadPath.isEmpty)
                .padding(.horizontal)
                .sheet(isPresented: self.$downloading) {
                    DownloadOutput()
                }
            }
        }.frame(minWidth: 600, maxWidth: 600, minHeight: 120, maxHeight: 120)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
