//
//  DetailViewController.m
//  Earthquake Monitor
//
//  Created by cristopherbg on 03/01/15.
//  Copyright (c) 2015 cristopher_bg. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *place;
@property (strong, nonatomic) IBOutlet UILabel *dateTime;
@property (strong, nonatomic) IBOutlet UILabel *magnitude;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        /*
         •	Magnitude of the earthquake
         •	The date and time of the earthquake
         •	The location of the earthquake including the depth
         */
        NSTimeInterval valueDate = [self.detailItem[@"properties"][@"time"] doubleValue]/1000;
        NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:valueDate];
        NSString *dateTimeStr = [NSString stringWithFormat:@"Date & time: %@",date];
        self.dateTime.text = [dateTimeStr substringToIndex:dateTimeStr.length-5];;
        self.place.text = self.detailItem[@"properties"][@"place"];
        self.magnitude.text = [NSString stringWithFormat:@"Magnitude: %@",self.detailItem[@"properties"][@"mag"]];
        
        NSArray *coordinates=self.detailItem[@"geometry"][@"coordinates"];
        float latitude = [coordinates[1] floatValue];
        float longitude = [coordinates[0] floatValue];
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.25, 0.25);
        MKCoordinateRegion region = {coord, span};
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setSubtitle:[NSString stringWithFormat:@"Depth:%@",coordinates[2]]];
        [annotation setTitle:self.place.text]; //You can set the subtitle too
        [annotation setCoordinate:coord];
        
        [self.mapView setRegion:region];
        [self.mapView addAnnotation:annotation];
        [self.mapView addAnnotation:annotation];
        [self.mapView selectAnnotation:annotation animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
