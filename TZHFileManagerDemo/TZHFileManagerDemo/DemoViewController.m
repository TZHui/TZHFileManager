//
//  DemoViewController.m
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//

#import "DemoViewController.h"
#import "TZHFileDownload.h"
#import "MJExtension.h"
#import "DemoModel.h"
#import "Masonry.h"

@interface DemoViewController ()

@property(nonatomic,strong)NSArray *fileArray;
@property(nonatomic,weak)UILabel *memoryLabel;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self creatUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     _memoryLabel.text = [NSString stringWithFormat:@"文件占用  %@",[TZHDownloadManager getFileCacheSize]];
}
-(void)loadData{
    
    //文件数组,此处做假数据,在您的项目中应为接口数据返回
#pragma mark --以下链接可能会失效,如果要看效果,建议将你的后台接口返回的下载链接填进去,运行即可
    NSArray *dataArray = @[@{@"fileName":@"doc格式文件.doc",@"fileUrl":@"http://down.51rc.com/dwndoc/WrittenExamination/WrittenExperiences/dwn00006795.doc"},
        @{@"fileName":@"ppt文档.ppt",@"fileUrl":@"http://down.51rc.com/dwndoc/Work/Occupational%20stress/dwn00006466.ppt"},
                        
       @{@"fileName":@"图片.jpg",@"fileUrl":@"https://gss0.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/21a4462309f79052b56a7dc60df3d7ca7acbd5d4.jpg"},
       @{@"fileName":@"pdf文件.pdf",@"fileUrl":@"http://d2.dajudeng.com:8092/files/20160225/201450_基于DSP和FPGA的Roip网关的设计与实现.pdf"},
       @{@"fileName":@"xls文件.xls",@"fileUrl":@"http://d2.dajudeng.com:8092/files/20160613/165531_120号文.xls"}
                         ];
    

#pragma mark --第一步创建 TZHFilesDownloadModel对象,将你的文件模型中的文件下载地址和文件名分别赋值给 TZHFilesDownloadModel对象的相应属性
    NSMutableArray *filesMutableArray = [NSMutableArray array];
    
    for(NSDictionary *dict in dataArray){
        
        DemoModel *model = [DemoModel mj_objectWithKeyValues:dict];
        

        TZHFilesDownloadModel *tzhModel = [[TZHFilesDownloadModel alloc]init];
        
        tzhModel.FileURL = model.fileUrl;
        tzhModel.FileName = model.fileName;
        
        [filesMutableArray addObject:tzhModel];
    }
    
    self.fileArray = filesMutableArray;
    
}

-(void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *clickBtn = [[UIButton alloc]init];
    
    [clickBtn setTitle:@"查看附件" forState:UIControlStateNormal];
    
    [clickBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.view addSubview:clickBtn];
    
    [clickBtn addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
    }];
    
//创建显示文件占内存空间显示框
    UIImageView *screenLineImageView = [[UIImageView alloc]init];
    
    screenLineImageView.image = [UIImage imageNamed:@"线框"];
    
    [self.view addSubview:screenLineImageView];
    
    [screenLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(clickBtn.mas_bottom).offset(100);
        make.leading.equalTo(self.view).offset(50);
        make.trailing.equalTo(self.view).offset(-50);
        make.height.equalTo(@40);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"清除文件";
    [self.view addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(screenLineImageView);
        make.leading.equalTo(screenLineImageView).offset(15);
    }];
    
    UILabel *memoryLabel = [[UILabel alloc]init];
    _memoryLabel = memoryLabel;
    memoryLabel.textColor = [UIColor lightGrayColor];
    memoryLabel.font = [UIFont systemFontOfSize:15];

    [self.view addSubview:memoryLabel];
    
    [memoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(screenLineImageView);
        make.trailing.equalTo(screenLineImageView).offset(-40);
    }];

    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setBackgroundColor:[UIColor blueColor]];
    [deleteBtn setTitle:@"删除所有文件" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(screenLineImageView.mas_bottom).offset(100);
    }];
    
    [deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
#pragma mark -- 想要显示下载的文件在沙盒中的内存调用 [TZHDownloadManager getFileCacheSize] 方法
    memoryLabel.text = [NSString stringWithFormat:@"文件占用  %@",[TZHDownloadManager getFileCacheSize]];
    
    
}

-(void)clickButton{
    
#pragma mark --第二步,在要查看附件文件的点击事件的实现方法中创建 TZHDownloadViewController对象可直接复制以下代码
    TZHDownloadViewController *tzhDownloadVC = [[TZHDownloadViewController alloc]init];
    
    //此处为跳转影藏底部tabBar
    tzhDownloadVC.hidesBottomBarWhenPushed = YES;
    
    tzhDownloadVC.filesArray = self.fileArray;
    [self.navigationController pushViewController:tzhDownloadVC animated:YES];
    
    //返回时显示子页面隐藏的tabBar
    self.hidesBottomBarWhenPushed = NO;
    
}


#pragma mark ---删除下载的所有文件调用以下方法
-(void)clickDeleteBtn{
    
    [TZHDownloadManager deleteFileFromCache];
    
    _memoryLabel.text = [NSString stringWithFormat:@"文件占用  %@",[TZHDownloadManager getFileCacheSize]];
    
}
@end
