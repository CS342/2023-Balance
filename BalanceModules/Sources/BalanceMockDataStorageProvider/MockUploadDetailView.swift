//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct MockUploadDetailView: View {
    let mockUpload: MockUpload
    
    
    var body: some View {
        List {
            Section(String(localized: "MOCK_UPLOAD_DETAIL_HEADER", bundle: .module)) {
                MockUploadHeader(mockUpload: mockUpload)
            }
            Section(String(localized: "MOCK_UPLOAD_DETAIL_BODY", bundle: .module)) {
                LazyText(text: mockUpload.body ?? "")
            }
        }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
    }
}
