//
//  BuddyListViewController.swift
//  wchat
//
//  Created by jerry on 2017/3/19.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit

class BuddyListViewController: UITableViewController,XxDL,ZtDL {
    
    @IBOutlet weak var mystatus: UIBarButtonItem!
    //未读消息数组
    var unreadList = [WXMessage]()
    
    //好友状态数组
    var ztList = [Zhuangtai]()
    
    //选择聊天的好友用户名
    var currentBuddyName = ""
    
    //已登入
    var logged = false
    
    //自己离线
    func meOff() {
        logoff()
    }
    
    //收到离线或未读消息
    func newMsg(aMsg: WXMessage) {
        //如果消息有正文
        if (aMsg.body.isEmpty == false) {
            //则加入到未读消息组
            unreadList.append(aMsg)
            
            //通知表格刷新
            self.tableView.reloadData()
        }
    }
    
    //上线状态处理
    func isON(zt: Zhuangtai) {
        //逐条查找
        for (index,oldzt) in (ztList).enumerated(){
            
            //如果找到旧的用户状态
            if (zt.name == oldzt.name) {
                //就移除掉旧的用户状态
                ztList.remove(at: index)
                
                //一旦找到，就不找了，退出循环
                break
            }
        }
    //添加新状态到状态数组
        ztList.append(zt)
        
    //表格刷新
        self.tableView.reloadData()
    }
    
    
    //下线状态处理
    func isOff(zt: Zhuangtai) {
        //逐条查找
        for (index,oldzt) in (ztList).enumerated(){
            
            //如果找到旧的用户状态
            if (zt.name == oldzt.name) {
                //更改旧的用户状态,为下线
                ztList[index].isOnline = false
                
                //一旦找到，就不找了，退出循环
                break
            }
        }

        
        //表格刷新
        self.tableView.reloadData()
    }
    
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //登入
    func login() {
        //清空未读和状态数组
        unreadList.removeAll(keepingCapacity: true)
        ztList.removeAll(keepingCapacity: true)
        zdl().connect()
        
        //导航左边按钮改为上线状态
        mystatus.image = UIImage(named: "上线")
        logged = true
        
        //取用户名
        let myID = UserDefaults.standard.string(forKey: "WU")
        
        //导航栏改标题"我"的好友
        self.navigationItem.title = myID! + "的好友"
        
        //通知表格更新数据
        self.tableView.reloadData()
    }
    
    //登出
    func logoff() {
        //清空未读和状态数组
        unreadList.removeAll(keepingCapacity: true)
        ztList.removeAll(keepingCapacity: true)
        zdl().disconnect()
        //导航左边按钮改为下线状态
        mystatus.image = UIImage(named: "下线")
        logged = false
        
        //通知表格更新数据
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //取用户名
        let myID = UserDefaults.standard.string(forKey: "WU")
        //取自动登录
        let autologin = UserDefaults.standard.bool(forKey: "wxautologin")
        
        //如果配置了用户名和自动登陆，开始登陆
        if (myID != nil && autologin) {
            self.login()
            self.navigationItem.title = myID! + "的好友"
            
        //其他情况，则转到登陆视图
        } else {
            self.performSegue(withIdentifier: "toLoginSegue", sender: self)
        }
        
        //接管消息代理
        zdl().xxdl = self
        //接管状态代理
        zdl().ztdl = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ztList.count
    }

    //单元格内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuddyCell", for: indexPath)
        
        //好友状态
        let online = ztList[indexPath.row].isOnline
        
        //好友的名称
        let name = ztList[indexPath.row].name
        
        //未读消息的条数
        var unreads = 0
        
        //查找相应好友的未读条数
        for msg in unreadList {
            if ( name == msg.from ) {
                unreads += 1
            }
        }
        
        //单元格的文本
        cell.textLabel?.text = name + "(\(unreads))"
        
        //根据状态切换单元格的图像
        if online == true {
            cell.imageView?.image = UIImage(named: "上线")
        } else {
            cell.imageView?.image = UIImage(named: "下线")
        }

        return cell
    }
    
    //选择单元格
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //保存好友用户名
        currentBuddyName = ztList[indexPath.row].name
        
        //跳转到聊天视图
        self.performSegue(withIdentifier: "toChatSegue", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    //反向专场
    @IBAction func unwindToBlist(segue:UIStoryboardSegue){
        //如果是登陆界面的完成按钮点击了，开始登陆
        let source = segue.source as! LoginViewController
        
        if source.requireLogin {
            //注销前一个用户
            self.logoff()
            
            //登陆现在用户
            self.login()
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
