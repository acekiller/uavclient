//
//  RecvPacket.h
//  UAVClient
//
//  Created by visu4l on 11. 6. 30..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

struct RecvData {
    char SV1; //방향 위
    char SV2; //방향
    char SV3; //방향
    char SV4; //방향
    long latitude; // 
    long longitude; // 
    unsigned char TrimFlags; // 미세조정
    unsigned char AuxSVFlag; // joystic mission function 
    unsigned char Command;  //착륙....etc (default function)
};
