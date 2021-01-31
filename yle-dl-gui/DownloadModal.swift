//
//  DownloadModal.swift
//  yle-dl-gui
//
//  Created by Juuso Nurminen on 31.1.2021.
//

import SwiftUI

struct DownloadOutput: View {
    var body: some View {
        VStack {
            Text("downloadInProgress".localized).padding(.top)
            ProgressView().padding(.vertical)
        }.frame(minWidth: 180, maxWidth: 180, minHeight: 120, maxHeight: 120)
    }
}

struct DownloadModal_Previews: PreviewProvider {
    static var previews: some View {
        DownloadOutput()
    }
}
