//
//  String+Extension.swift
//  Movie
//
//  Created by Navneet on 5/1/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

extension String {
    var urlEncodedString: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
