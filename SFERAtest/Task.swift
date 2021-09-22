//
//  Task.swift
//  SFERAtest
//
//  Created by Ruslan Dalgatov on 15.09.2021.
//

import Foundation

class Task {
    let name: String
    var time: Int
    let creationDate = Date()
    var completed = false
  
    init(name: String, time: Int) {
    self.name = name
    self.time = time
  }
}
