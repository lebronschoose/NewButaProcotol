//
//  NSDate+CL.m
//  CLWeeklyCalendarView
//
//  Created by Caesar on 10/12/2014.
//  Copyright (c) 2014 Caesar. All rights reserved.
//

#import "NSDate+CL.h"

@implementation NSDate (CL)


-(NSDate *)getWeekStartDate: (NSInteger)weekStartIndex
{
    int weekDay = [[self getWeekDay] intValue];
    
    NSInteger gap = (weekStartIndex <=  weekDay) ?  weekDay  : ( 7 + weekDay );
    NSInteger day = weekStartIndex - gap;
    
    return [self addDays:day];
}

-(NSNumber *)getWeekDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    return [NSNumber numberWithInteger:([comps weekday])];
}

-(NSDate *)addDays:(NSInteger)day
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = day;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    return [theCalendar dateByAddingComponents:dayComponent toDate:self options:0];
}

- (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

-(NSString *)getDayOfWeekShortString
{
    static NSDateFormatter *shortDayOfWeekFormatter;
    if(!shortDayOfWeekFormatter){
        shortDayOfWeekFormatter = [[NSDateFormatter alloc] init];
//        NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU_POSIX"];
        NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:[self getPreferredLanguage]];
        [shortDayOfWeekFormatter setLocale:en_AU_POSIX];
        [shortDayOfWeekFormatter setDateFormat:@"E"];
    }
    NSString *s = [shortDayOfWeekFormatter stringFromDate:self];
    return s;
}

-(NSString *)getDateOfMonth
{
    static NSDateFormatter *dateFormaater;
    if(!dateFormaater){
        dateFormaater = [[NSDateFormatter alloc] init];
//        NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU_POSIX"];
        NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:[self getPreferredLanguage]];
        [dateFormaater setLocale:en_AU_POSIX];
        [dateFormaater setDateFormat:@"d"];
    }
    NSString *s = [dateFormaater stringFromDate:self];
    return s;
}

- (NSDate*)midnightDate {
    return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self]];
}
-(BOOL) isSameDateWith: (NSDate *)dt{
    return  ([[self midnightDate] isEqualToDate: [dt midnightDate]])?YES:NO;
}
- (BOOL)isDateToday {
    return [[[NSDate date] midnightDate] isEqual:[self midnightDate]];
}
- (BOOL)isWithinDate: (NSDate *)earlierDate toDate:(NSDate *)laterDate
{
    NSTimeInterval timestamp = [[self midnightDate] timeIntervalSince1970];
    NSDate *fdt = [earlierDate midnightDate];
    NSDate *tdt = [laterDate midnightDate];
    
    BOOL isWithinDate = (timestamp >= [fdt timeIntervalSince1970] && timestamp <= [tdt timeIntervalSince1970]);
    
    return isWithinDate;
    
}
- (BOOL)isPastDate {
    NSDate* now = [NSDate date];
    if([[now earlierDate:self] isEqualToDate:self]) {
        return YES;
    } else {
        return NO;
    }
}
@end
