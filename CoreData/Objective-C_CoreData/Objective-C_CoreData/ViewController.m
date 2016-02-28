//
//  ViewController.m
//  Objective-C_CoreData
//
//  Created by Kxx.xxQ 一生相伴 on 16/2/28.
//  Copyright © 2016年 Asahi_Kuang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

static NSString *const identifier = @"cellIdentifier";
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

// 数组 存储core data 实体对象。
@property (strong, nonatomic) NSMutableArray *listItems;
@end

@implementation ViewController

#pragma mark - lazy loading
- (NSMutableArray *)listItems {
    if (!_listItems) {
        _listItems = [NSMutableArray array];
    }
    return _listItems;
}
#pragma mark --

#pragma mark - life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 查询数据
    [self executeDataItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --

#pragma mark - selector
- (IBAction)addNewItem:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Item" message:@"add new item to core data." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *completeAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        
        if (alert.textFields.firstObject.text.length == 0) {
            return;
        }
        [self addNewItems:alert.textFields.firstObject.text];
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //
        textField.placeholder = @"Input new item here.";
    }];
    [alert addAction:completeAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark --

#pragma mark - data handler
// 获取上下文
- (NSManagedObjectContext *)getContext {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    return delegate.managedObjectContext;
}

// 新增数据 方法
- (void)addNewItems:(NSString *)newItemName {
    
    NSManagedObjectContext *context = [self getContext];
    // 初始化core data 实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:context];
    NSManagedObject *item = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    // 给实体属性赋值。
    [item setValue:newItemName forKey:@"itemName"];
    
    NSError *__autoreleasing error = nil;
    
    // 执行存储数据
    [context save:&error];
    if (!error) {
        [self.listItems addObject:item];
    }
    else {
        NSLog(@"存储错误！----> %@", [error localizedDescription]);
    }
    [self.listTableView reloadData];
}

// 查询数据方法。
- (void)executeDataItem {
    NSManagedObjectContext *context = [self getContext];
    // 初始化查询请求。
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ListItem"];
    NSError *__autoreleasing error = nil;
    // 请求的结果。数组
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        // 将请求的core data 数据放进数据源数组。
        [self.listItems addObjectsFromArray:results];
//
    }
    else {
        NSLog(@"查询错误！----> %@", [error localizedDescription]);
    }
    [self.listTableView reloadData];
}

- (void)deleteDataItemAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self getContext];
    
    // 从上下文中删除对象
    [context deleteObject:self.listItems[indexPath.row]];
    // 移除数组中对应的实体对象。
    [self.listItems removeObjectAtIndex:indexPath.row];

    [self.listTableView reloadData];
}
#pragma mark --

#pragma mark - UITableViewDelegate && dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSManagedObject *objectItem = self.listItems[indexPath.row];
    cell.textLabel.text = [objectItem valueForKey:@"itemName"];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //
        [self deleteDataItemAtIndexPath:indexPath];
    }];
    return @[deleteAction];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark --

@end
