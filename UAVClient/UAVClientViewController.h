//
//  UAVClientViewController.h
//  UAVClient
//
//  Created by visu4l on 11. 6. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

#import "NetworkController.h"

@interface UAVClientViewController : UIViewController <CLLocationManagerDelegate>{

    IBOutlet UIButton *btnConnect;
    IBOutlet UITextView *textStatus;
    IBOutlet UIImageView *compassImg;
    
    NetworkController *controller;
    
    CLLocationManager *locationManager;
    
    //test ui..
    IBOutlet UITextField *textLat;
    IBOutlet UITextField *textLng;
    IBOutlet UITextField *textHeading;
    
}

@property (nonatomic, retain) IBOutlet UIButton *btnConnect;
@property (nonatomic, retain) IBOutlet UITextView *textStatus;
@property (nonatomic, retain) IBOutlet UIImageView *compassImg;

@property (nonatomic, retain) NetworkController *controller;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) IBOutlet UITextField *textLat;
@property (nonatomic, retain) IBOutlet UITextField *textLng;
@property (nonatomic, retain) IBOutlet UITextField *textHeading;

-(void) setup;
-(IBAction) clieckConnect:(id) sender;
-(Boolean) isNetworkReachable;

-(void) updateStatus:(NSString *)msg;
-(void) alertNotify:(NSString *)message;


@end
