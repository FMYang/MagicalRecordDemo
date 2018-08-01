
//
//  TaskOperation.swift
//  MagicalRecordDemo
//
//  Created by yfm on 2018/8/1.
//  Copyright © 2018年 yfm. All rights reserved.
//

import Foundation

class TaskOperation: Operation {

    var taskBlock: (() -> ())?

    override func main() {
        if let block = taskBlock {
            block()
        }
    }
}
