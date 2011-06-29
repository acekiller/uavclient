//
//  SendSocket.h
//  Socket
//
//  Created by visu4l on 11. 6. 28..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


struct sockaddr_in {
    
    unsigned char State_Flag; 
    long latitude;      // 위도..
    long longitude;     // 경도
    unsigned char numSV; // gps number... 
    short heading;      //나침반
    short gspeed;       // 속도
    short msl;          // 고도(해저기준)
    short roll;         //?
    short pitch;        //?
    short yaw;          //?

    
};

