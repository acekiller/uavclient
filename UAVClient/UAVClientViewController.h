//
//  UAVClientViewController.h
//  UAVClient
//
//  Created by visu4l on 11. 6. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/coreMotion.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


#import "NetworkController.h"
#import "SendPacket.h"
#import "RecvPacket.h"

@interface UAVClientViewController : UIViewController <CLLocationManagerDelegate>{

    NetworkController *controller;
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;

    //data
    long latitude;
    long longitude;
    short heading; 
    short gspeed;       // 속도
    short altitude;     // 고도(해발)
    short roll;         //roll
    short pitch;        //pitch
    short yaw;          //yaw
    
    //basic ui
    IBOutlet UIButton *btnConnect;
    IBOutlet UITextView *textStatus;
    IBOutlet UIImageView *compassImg;
    
    //test ui
    IBOutlet UITextField *textLat;
    IBOutlet UITextField *textLng;
    IBOutlet UITextField *textAli;
    IBOutlet UITextField *textHeading;
    
    IBOutlet UITextField *textRoll;
    IBOutlet UITextField *textPitch;
    IBOutlet UITextField *textYaw;
    
}

@property (nonatomic, retain) IBOutlet UIButton *btnConnect;
@property (nonatomic, retain) IBOutlet UITextView *textStatus;
@property (nonatomic, retain) IBOutlet UIImageView *compassImg;

@property (nonatomic, retain) NetworkController *controller;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CMMotionManager *motionManager;

@property (nonatomic, retain) IBOutlet UITextField *textLat;
@property (nonatomic, retain) IBOutlet UITextField *textLng;
@property (nonatomic, retain) IBOutlet UITextField *textAli;
@property (nonatomic, retain) IBOutlet UITextField *textHeading;

@property (nonatomic, retain) IBOutlet UITextField *textRoll;
@property (nonatomic, retain) IBOutlet UITextField *textPitch;
@property (nonatomic, retain) IBOutlet UITextField *textYaw;


-(void) setup;
-(IBAction) clickConnect:(id) sender;
-(IBAction) clickSend:(id) sender;
-(Boolean) isNetworkReachable;
-(void) updateGyro;
-(void) makeSendPacket;
-(void) updateStatus:(NSString *)msg;
-(void) alertNotify:(NSString *)message;


@end
