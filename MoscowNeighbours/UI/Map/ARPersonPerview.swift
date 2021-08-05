//
//  ARPersonPerview.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.08.2021.
//

import UIKit
import QuickLook
import ARKit

final class ARPersonPerview: NSObject, QLPreviewControllerDataSource {
    
//    override func viewDidAppear(_ animated: Bool) {
//        let previewController = QLPreviewController()
//        previewController.dataSource = self
//        present(previewController, animated: true, completion: nil)
//    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let path = Bundle.main.path(forResource: "CosmonautSuit", ofType: "reality") else { fatalError("Couldn't find the supported input file.") }
        let url = URL(fileURLWithPath: path)
        return url as QLPreviewItem
    }
    
}
