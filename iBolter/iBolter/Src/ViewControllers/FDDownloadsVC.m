//
//  FDDownloadsVC.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#warning TODO: 进入下一级目录
#warning TODO: 文件删除
#warning TODO: 文件改名

#import "FDDownloadsVC.h"

@interface FDDownloadsVC () <UITableViewDelegate, UITableViewDataSource> {
    NSString        *_path;
    NSArray         *_files;
    
    UITableView     *_tv;
}

@end

@implementation FDDownloadsVC

-(id)initWithPath:(NSString *)aPath {
    self = [super init];
    if (self) {
        _path = aPath;
    }
    return self;
}

-(void)initData {
    // check root dir path
    if (_path.length <= 0) {
        _path = [FDUtil appDirDoc];
        self.title = @"Downloads";
    } else {
        self.title = [_path lastPathComponent];
    }
    
    [self refreshFiles];
}

-(void)refreshFiles {
    // get files
    _files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_path error:nil];
    
    // test create empty file
//    if (_files.count == 0) {
//        NSString *fileName = @"test.txt";
//        [self createEmptyFileWithName:fileName at:_path];
//        _files = @[fileName];
//    }
    
    [_tv reloadData];
}

- (void)viewDidLoad
{
    [self initData];
    
    [super viewDidLoad];
    UIBarButtonItem *addFolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createFolderAction)];
    self.navigationItem.rightBarButtonItem = addFolderItem;
    
    self.view.backgroundColor = FDColor.sharedInstance.midnightBlue;
    
    // create table view
    _tv = [UITableView new];
    _tv.delegate = self;
    _tv.dataSource = self;
    [self.view addSubview:_tv];
    
    // auto layout
    [self setupLayoutConstraints];
}

-(void)setupLayoutConstraints {
    _tv.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *vflDic = NSDictionaryOfVariableBindings(_tv);
    [self addConstraintsWithVFLString:@"|[_tv]|" views:vflDic];
    [self addConstraintsWithVFLString:@"V:|[_tv]|" views:vflDic];
}

#pragma mark - table view datasource
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _files.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *fileName = _files[indexPath.row];
    cell.textLabel.text = fileName;
    if ([self isDirectory:fileName]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - file operations
-(void)createEmptyFileWithName:(NSString *)aFileName at:(NSString *)aPath {
    if (aFileName.length && aPath.length) {
        NSString *filePath = [aPath stringByAppendingPathComponent:aFileName];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
}

-(void)createFolderWithName:(NSString *)aFileName at:(NSString *)aPath {
    if (aFileName.length && aPath.length) {
        NSString *filePath = [aPath stringByAppendingPathComponent:aFileName];
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

-(BOOL)isDirectory:(NSString *)aFileName {
    if (aFileName) {
        NSString *filePath = [_path stringByAppendingPathComponent:aFileName];
        BOOL isDirectory = NO;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (exist && isDirectory) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - actions
-(void)createFolderAction {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Folder"
                                                    message:@"Please Enter the name of new folder"
                                           cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel"]
                                           otherButtonItems:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    RIButtonItem *createBtn = [RIButtonItem itemWithLabel:@"Create" action:^{
        NSString *folderName =  [alert textFieldAtIndex: 0].text;
        if (folderName.length) {
            [self createFolderWithName:folderName at:_path];
            [self refreshFiles];
        }
    }];
    
    [alert addButtonItem:createBtn];
    
    [alert show];
}

@end
