//
//  MasterViewController.m
//  Earthquake Monitor
//
//  Created by cristopherbg on 03/01/15.
//  Copyright (c) 2015 cristopher_bg. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#define kURLService @"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"
NSString * const kUserProfileImageDidLoadNotification = @"com.Earthquake-Monitor.user.profile-image.loaded";

@interface MasterViewController ()
@property (readwrite, nonatomic, strong) NSArray *objects;
@property (readwrite, nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSURLSessionTask *task = [manager GET:kURLService parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.objects = responseObject[@"features"];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"EarthQuake Monitor Summary";
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.tableView.rowHeight = 70.0f;
    
    [self reload:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = self.objects[indexPath.row];
    cell.textLabel.text = object[@"properties"][@"place"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Mag: %@",object[@"properties"][@"mag"]];
    cell.backgroundColor = [self getColor:object];
    return cell;
}
-(UIColor*)getColor:(id)object{
    double magnitud = [object[@"properties"][@"mag"] doubleValue];
    double valueColor = 0.9 + (magnitud/100.0);//magnitud - myInt;
    UIColor *currentColor;
    if (magnitud<=0.9) {
        //+ (UIColor *)greenColor;      // 0.0, 1.0, 0.0 RGB
        currentColor = [UIColor colorWithRed:0.0 green:valueColor blue:0.0 alpha:0.9];
    }else if (magnitud<9.0){
        //+ (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB
        currentColor = [UIColor colorWithRed:valueColor green:valueColor blue:0.0 alpha:0.9];
    }else if (magnitud<=9.9){
        //+ (UIColor *)redColor;        // 1.0, 0.0, 0.0 RGB
        currentColor = [UIColor colorWithRed:valueColor green:0.0 blue:0.0 alpha:0.9];
    }
    return currentColor;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end
