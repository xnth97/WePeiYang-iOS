//
//  NewsCommentViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/13.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "NewsComment.h"
#import "NewsCommentTextView.h"
#import "NewsCommentTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MsgDisplay.h"
#import "twtSDK.h"
#import "AFNetworking.h"
#import "AccountManager.h"
#import "WePeiYang-Swift.h"

@interface NewsCommentViewController ()<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@end

@implementation NewsCommentViewController

@synthesize index;
@synthesize commentArray;

- (id)init {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self registerClassForTextView:[NewsCommentTextView class]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = YES;
    self.inverted = NO;
    
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //slk 1.9.2 bug 临时解决方案
    [self registerPrefixesForAutoCompletion:@[@"#"]];
    
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // In order to clear cached text in NewsCommentTextView.
    [self clearCachedText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Action

- (void)didPressRightButton:(id)sender {
//    [self.textView refreshFirstResponder];
    
    // MARK: 判断 token 是否存在
    if ([AccountManager tokenExists]) {
        [MsgDisplay showLoading];
        [twtSDK postNewsCommentWithIndex:index content:self.textView.text success:^(NSURLSessionDataTask *task, id responseObj) {
            [self.navigationController popViewControllerAnimated:YES];
            [MsgDisplay showSuccessMsg:@"评论成功"];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MsgDisplay showErrorMsg:@"评论失败"];
            //NSLog(error.localizedDescription);
        }];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [MsgDisplay showSuccessMsg:@"要先登录才能评论噢！"];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    [super didPressRightButton:sender];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    NewsCommentTableViewCell *cell = (NewsCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCommentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSInteger row = [indexPath row];
    NewsComment *comment = commentArray[row];
    [cell setCommentObject:comment];
    cell.transform = self.tableView.transform;
    return cell;
}

#pragma mark - DZNEmpty

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无评论";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
