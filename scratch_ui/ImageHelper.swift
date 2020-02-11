//
//  ImageHelper.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-11.
//  Copyright © 2020 Artorias. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageHelper: Hashable {
    var name: String
    var image: UIImage?
    
    init (name: String, image: UIImage?) {
        self.name = name
        self.image = image
    }
}
