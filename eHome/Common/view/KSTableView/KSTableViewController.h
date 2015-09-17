//
//  KSTableViewController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-26.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSScrollViewServiceController.h"
#import "KSCollectionViewConfigObject.h"

typedef void(^tableViewDidSelectedBlock) (UITableView* tableView,NSIndexPath* indexPath,KSDataSource* dataSource,KSCollectionViewConfigObject* configObject);

@interface KSTableViewController : KSScrollViewServiceController<UITableViewDataSource, UITableViewDelegate>{
    UITableView*                 _tableView;
}

@property (nonatomic, strong) UIView*           tableHeaderView;
@property (nonatomic, strong) UIView*           tableFooterView;

@property (nonatomic, strong) tableViewDidSelectedBlock  tableViewDidSelectedBlock;

// tableView的删除操作时使用
@property (nonatomic, strong) NSMutableArray*   collectionDeleteItems;

// init method
-(instancetype)initWithFrame:(CGRect)frame withConfigObject:(KSCollectionViewConfigObject*)configObject;

// 设置KSViewCell的类型，用于反射viewCell，在KSCollectionViewCell中使用
-(void)registerClass:(Class)viewCellClass;

// 获取collectionView
-(UITableView*)getTableView;

// 更新configObject
-(void)updateCollectionConfigObject:(KSCollectionViewConfigObject*)configObject;

// 删除tableViewCell
-(void)deleteCollectionCellProccessBlock:(void(^)(NSArray* collectionDeleteItems,KSDataSource* dataSource))proccessBlock completeBolck:(void(^)(void))completeBlock;

// method used by subclass
// 公用函数 在子类的- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath中调用
-(void)configTableView:(UITableView *)tableView withCollectionViewCell:(UITableViewCell*)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath;

// 自使用高度，配合autoAdjustFrameSize使用，autoAdjustFrameSize为YES时表示高度由cell的个数决定
-(void)sizeToFit;

@end
