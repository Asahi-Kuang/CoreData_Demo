# Core Data Demo
####Author: Asahi Kuang
####[github主页](https://github.com/Asahi-Kuang)
####Edition: Swift、Objective-C
--
#####本项目演示Core Data的基本使用方法。内有Objective-C和Swift两个版本。
--

####代码讲解(以Swift为例):
一. 新建工程勾选Core Data选项框。

二. 打开`CoreData_Demo.xcdatamodeld`文件。新增实体，取名为“ListItem”。新建实体属性“itemName”，类型为“String”。

![pic url](https://github.com/Asahi-Kuang/picture/blob/master/entity.png?raw=true)


三. 给工程项目添加CoreData框架。

![pic url](https://github.com/Asahi-Kuang/picture/blob/master/framework.png?raw=true)

四. 导入框架框架。

![pic url](https://github.com/Asahi-Kuang/picture/blob/master/import.png?raw=true)


五. 查询core data中数据。

```
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
        // 刷新列表
        listTableView.reloadData()
    }
```

六. 存储数据，给实体新增属性值。

```
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
```

七. 删除数据。

```
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
```

####App screenShot
![pic url](https://github.com/Asahi-Kuang/picture/blob/master/Core%20Data.gif?raw=true)

