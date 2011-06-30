//
//  UAVClientViewController.m
//  UAVClient
//
//  Created by visu4l on 11. 6. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UAVClientViewController.h"

@implementation UAVClientViewController


@synthesize btnConnect;

@synthesize textStatus;
@synthesize controller;
@synthesize locationManager;
@synthesize motionManager;

@synthesize compassImg;

@synthesize textLat;
@synthesize textLng;
@synthesize textAli;
@synthesize textHeading;

@synthesize textRoll;
@synthesize textPitch;
@synthesize textYaw;


-(void) setup{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    locationManager.headingFilter = kCLHeadingFilterNone;
    [locationManager startUpdatingHeading];
    
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0f/1.0f; //1sec
    if(motionManager.gyroAvailable){
        [motionManager startDeviceMotionUpdates];
    
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0/1.0 
                                                          target:self selector:@selector(updateGyro) 
                                                        userInfo:nil repeats:YES];
    }else{
        [motionManager release];
    }
}

/**
 * network check
 * run on wifi
 */
-(Boolean) isNetworkReachable 
{
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
	
    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
	

    /*
    if(flag & kSCNetworkFlagsReachable){  // connected network. but, don't know network. 3g or wifi
        if(flag & kSCNetworkReachabilityFlagsIsWWAN){ 
            return false; //3g
        }else {
            return true;  //wifi
        }
    }else {
        return false;  // not connected any network
    }
     */
}

/*
 * click Connect button
 * 
 */
-(IBAction) clickConnect:(id)sender{
    
    controller = [[NetworkController alloc] init];
    
    // TODO : call createSock by thead
//    [control/ler performSelectorOnMainThread:@selector(createSock) withObject:<#(id)#> waitUntilDone:NO];


    
    if([controller createSock]){
        [btnConnect setEnabled:false];
        [self updateStatus:@"OK. Connect to Server!"]; 
    }else{
        [self updateStatus:@"check network. and Retry connect"]; 
    }
}

-(IBAction) clickSend:(id)sender{
    
    [self makeSendPacket];
}

/*
 * Location infomation update(latitude, longitude)
 */
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    double lat = newLocation.coordinate.latitude;
    double lng = newLocation.coordinate.longitude;
    short ali = newLocation.altitude;
    
    latitude = (long) lat;
    longitude = (long) lng;
    altitude = ali;
    
    textLat.text = [NSString stringWithFormat:@"%.8f", lat];
    textLng.text = [NSString stringWithFormat:@"%.8f", lng];
    textAli.text = [NSString stringWithFormat:@"%f", ali];
    
    
}

/*
 * Location infomation update (heading)
 */
-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    double head = newHeading.magneticHeading;
    CGFloat angle = (head*M_PI)/180;
    
    textHeading.text = [NSString stringWithFormat:@"%f", angle];
    
    compassImg.transform = CGAffineTransformMakeRotation(-angle);
    [UIView commitAnimations];
    
    heading = (short) head;
}

/*
 * Location error handler
 */
-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self updateStatus:[NSString stringWithFormat:@"locationManager error : %@", error.accessibilityValue]];
}

/*
 * Gyroscope Info (roll, pitch, yaw)
 */

-(void) updateGyro{
    
    CMDeviceMotion *motion = motionManager.deviceMotion;
    
    CMAttitude *attitude = motion.attitude;
    
    roll = (short)attitude.roll;
    pitch = (short)attitude.pitch;
    yaw = (short)attitude.yaw;
    
    textRoll.text = [NSString stringWithFormat:@"%f", attitude.roll];
    textPitch.text = [NSString stringWithFormat:@"%f", attitude.pitch];
    textYaw.text = [NSString stringWithFormat:@"%f", attitude.yaw];
    
}


-(void) makeSendPacket{
    struct SendData *data = (struct SendData*) malloc(sizeof(struct SendData));
    
    data->State_Flag = 'c';
    data->latitude = latitude;
    data->longitude = longitude;
    data->gspeed = 0;
    data->heading = heading;
    data->roll = roll;
    data->pitch = pitch;
    data->yaw = yaw;
    data->msl = altitude;
    
    //TODO : make send data
    [controller sendPacket:data];

}


//
// util functions...
//

-(void) updateStatus:(NSString *)msg{
    
    textStatus.text = [NSString stringWithFormat:@"%@ \n%@", textStatus.text, msg];
    
}

-(void) alertNotify:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notify" message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}




- (void)dealloc
{
    [controller release];
    [motionManager release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

//app start
-(void) viewDidLoad{
    
    [self updateStatus:@"Start application"];
    
    [btnConnect setEnabled:false];
    
    if([self isNetworkReachable]){
        [self updateStatus:@"connected WIFI"];
        [btnConnect setEnabled:true];
        [self setup];
        
    }else{
        [self updateStatus:@"Please, connect to WIFI"];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return YES;
    // UI fix to Protrait
    return (interfaceOrientation >= UIInterfaceOrientationLandscapeLeft);
}

@end
