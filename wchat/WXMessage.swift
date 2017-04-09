//
//  WXMessage.swift
//  wchat
//
//  Created by jerry on 2017/3/19.
//  Copyright © 2017年 jerry. All rights reserved.
//

import Foundation

//好友消息结构
struct WXMessage {
    var body = ""
    var from = ""
    var isComposing = false
    var isDelay = false
    var isMe = false
}

struct Zhuangtai {
    var name = ""
    var isOnline = false
}
