//
//  DetailViewController.h
//  Earthquake Monitor
//
//  Created by cristopherbg on 03/01/15.
//  Copyright (c) 2015 cristopher_bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

