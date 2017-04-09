//
//  AppDelegate.swift
//  wchat
//
//  Created by jerry on 2017/3/19.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate {

    var window: UIWindow?
    
    //通道
    var xs:XMPPStream?
    //服务器是否开启
    var isOPen = false
    //密码
    var pwd = ""
    
    //状态代理
    var ztdl:ZtDL?
    
    //消息代理
    var xxdl:XxDL?
    
    //收到消息
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        //如果是聊天消息
        if message.isChatMessage() {
            var msg = WXMessage()
            
            //对方正在输入
            if message.elements(forName: "composing") != nil {
                msg.isComposing = true
            }
            
            //离线消息
            if message.elements(forName: "delay") != nil {
                msg.isDelay = true
            }
            
            //消息正文
            if let body = message.elements(forName: "body") {
                msg.body = body.description
        }
            //完整的用户名
            msg.from = message.from().user + "@" + message.from().domain
            
            //添加到消息代理中
            xxdl?.newMsg(aMsg: msg)
        }
    }
    
    //收到状态
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        //我自己的用户名
        let myUser = sender.myJID.user
        
        //好友的用户名
        let user = presence.from().user
        
        //用户所在域
        let domain = presence.from().domain
        
        //状态类型
        let pType = presence.type()
        
        //如果状态不是自己的
        if (user != myUser) {
            //状态保存的结构
            var zt = Zhuangtai()
            //保存了状态的完整用户名
            
            zt.name = user! + "@" + domain!
            //上线
            if pType == "available" {
                zt.isOnline = true
                ztdl?.isON(zt: zt)
                
            } else if pType == "unavailabel" {
                ztdl?.isOff(zt: zt)
            }
        }
    }
    
    
    
    //连接成功
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        isOPen = true
        
        do {
            //验证密码
            try xs!.authenticate(withPassword: pwd) }
        catch let error as NSError{
                print(error.description)
        }
        
        
    }
    
    //验证成功
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        //上线
        goOnline()
    }
    
    
    //建立通道
    func buildSteam(){
        xs = XMPPStream()
        xs?.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    //发送上线状态
    func goOnline(){
        let p = XMPPPresence()
        xs!.send(p)
    }
    
    //发送下线状态
    func goOffline(){
        let p = XMPPPresence(type:"unavailabe")
        xs!.send(p)
    }
    
    //连接服务器(查看服务器是否可连接)
    func connect() -> Bool{
    buildSteam()
        
        if xs!.isConnected(){
            return true
        }
        
        let user = UserDefaults.standard.string(forKey: "WU")
        let password = UserDefaults.standard.string(forKey: "WPS")
        let server = UserDefaults.standard.string(forKey: "WServer")
        
        if (user != nil && password != nil){
            
            //通道的用户名
            xs!.myJID = XMPPJID.init(string: user!)
            xs!.hostName = server!
            //密码保存备用
            pwd = password!
            do{
                try xs!.connect(withTimeout: 5000)
            }catch let error as NSError{
                    print(error.description)
            }
                
            
        }
        
        
        return false
    }
    
    //断开链接
    func disconnect(){
        if xs != nil {
            if xs!.isConnected() {
                goOffline()
                xs!.disconnect()
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

