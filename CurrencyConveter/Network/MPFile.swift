//
//  MPFile.swift
//
//  Created by Mac on 3/5/19.
//  Copyright © 2019 Eissa. All rights reserved.
//
//
//
//  Created by Mac on 3/5/19.
//  Copyright © 2019 Eissa. All rights reserved.
//
import ObjectMapper

class MPfile {
    
    let data: Data
    var key = ""
    var name = ""
    var memType = ""
    init(data: Data) {
        self.data = data
    }
    convenience init(data: Data, key: String,name: String, memType: String ) {
        self.init(data: data)
        self.name = name
        self.memType = memType
        self.key = key
    }
    convenience init(image: UIImage) {
        let name = String(Date().timeIntervalSince1970) + ".jpeg"
        self.init(data: image.jpegData(compressionQuality: 0.5)!, key: "file", name: name, memType: "image/jpeg")
    }
}
