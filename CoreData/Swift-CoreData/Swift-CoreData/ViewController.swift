//
//  ViewController.swift
//  Swift-CoreData
//
//  Created by Kxx.xxQ 一生相伴 on 16/2/28.
//  Copyright © 2016年 Asahi_Kuang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    let identifier: String = "cellIdentifier"
    // 用来存储coreData实体对象
    var listitems: Array<NSManagedObject> = [NSManagedObject]()
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        coreDataHandler()
        
    }
    // 查询数据
    func coreDataHandler() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // 获取上下文
        let context = appdelegate.managedObjectContext
        // 初始化查询请求
        let request = NSFetchRequest(entityName: "ListItem")
        
        do{
            let results = try context.executeFetchRequest(request)
            listitems = results as! [NSManagedObject]
        }catch{
            print("查询失败!")
        }
        listTableView.reloadData()
    }

    
    // 存储数据
    func storeData(data: String) {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appdelegate.managedObjectContext
        // 从上下文获取实例
        let entity = NSEntityDescription.entityForName("ListItem", inManagedObjectContext: context)
        // 插入新实体
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        // 给实体对象属性赋值
        item.setValue(data, forKey: "itemName")
        
        do{
            // 存储数据
            try context.save()
            listitems.append(item)
        }catch{
            print(error)
        }
        listTableView.reloadData()
    }
    
    // 删除数据
    func deleteData(indexPath: NSIndexPath) {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appdelegate.managedObjectContext
        // 删除实体对象
        context.deleteObject(self.listitems[indexPath.row])
        // 删除数组对应的实体对象
        self.listitems.removeAtIndex(indexPath.row)
        // 重载对应的row
        self.listTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    @IBAction func addNewItem(sender: UIBarButtonItem) {
        let addNewItemAlert = UIAlertController(title: "Add New Item", message: "Input the new item you want to add.", preferredStyle: .Alert)
        let completeAction = UIAlertAction(title: "Ok", style: .Default) { (okButton) -> Void in
            //
            if addNewItemAlert.textFields!.first!.text != nil {
                
                self.storeData(addNewItemAlert.textFields!.first!.text!)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (cancelButton) -> Void in
            //
        }
        addNewItemAlert.addTextFieldWithConfigurationHandler { (inputText) -> Void in
            //
            inputText.placeholder = "Input new item name here."
        }
        addNewItemAlert.addAction(completeAction)
        addNewItemAlert.addAction(cancelAction)
        self.presentViewController(addNewItemAlert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listitems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        let itemEntity = listitems[indexPath.row]
        cell!.textLabel!.text = itemEntity.valueForKey("itemName") as? String
        return cell!
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "删除") { (delete, indexPath) -> Void in
            //

            self.deleteData(indexPath)
        }
        
        deleteAction.backgroundColor = UIColor(red: 41/255.0, green: 202/255.0, blue: 184/255.0, alpha: 1.0)
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {return true}
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {return 65}
}

