//
//  BLCDataSource.h
//  Blocstagram
//
//  Created by Inioluwa Work Account on 21/04/2016.
//  Copyright © 2016 bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLCDataSource : NSObject

+(instancetype)sharedInstance;

-(void)removeObjectAtIndex:(NSInteger)index;

@property (nonatomic, strong, readonly) NSArray *mediaItems;



@end
