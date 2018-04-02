//
//  JsonObject.m
//  hsimapp
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "JsonObject.h"

@implementation JsonObject

+ (NSDictionary *)jsonForAPI:(NSString *)api
{
    NSError *error;
    // 获取首页相关数据
    //      参数：checkcode
    if([api isEqualToString:@"getMainInfo"])
    {
        NSData *data = [@"{\"title\":\"互动首页\",\"indexfoucs\":[{\"title\":\"注册指2引\",\"link\":\"http://www.bwxkj.com/index.php?s=/Home/Article/detail/id/126/stype/13.html\",\"image\":\"/Uploads/Picture/2016-05-05/572b07f164cce.png\"},{\"title\":\"开启2用车新时代\",\"link\":\"http://www.rabbitpre.com/m/RQYJnVfEk#\",\"image\":\"/Uploads/Picture/2016-05-05/572b0818ea800.png\"},{\"title\":\"会23员手册\",\"link\":\"http://www.bwxkj.com/index.php?s=/Home/Article/detail/id/132/stype/13.html\",\"image\":\"/Uploads/Picture/2016-05-05/572b0829a2196.png\"}],\"unread\":[1,2,3,12,0,40,198,0],\"recentlist\":[{\"type\":1,\"title\":\"今天发布全校公告\",\"desc\":\"关于2014—2015学年勤工助学岗...\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":2,\"title\":\"语文作业\",\"desc\":\"关于2014—2015学年勤工助学岗...\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":4,\"title\":\"数学成绩\",\"desc\":\"2016年三年级二班第3次模拟考试\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":6,\"title\":\"什么时候放暑假\",\"desc\":\"请问今年到暑假是什么时候开始放...\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":2,\"title\":\"语文作业\",\"desc\":\"关于2014—2015学年勤工助学岗...\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":1,\"title\":\"今天发布全校公告\",\"desc\":\"关于2014—2015学年勤工助学岗...\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":2,\"title\":\"语文作业\",\"desc\":\"关于2014—2015学年勤工助学岗...\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":4,\"title\":\"数学成绩\",\"desc\":\"2016年三年级二班第3次模拟考试\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":6,\"title\":\"什么时候放暑假\",\"desc\":\"请问今年到暑假是什么时候开始放...\",\"time\":\"2016-06-30 12:23:09\"},{\"type\":2,\"title\":\"语文作业\",\"desc\":\"关于2014—2015学年勤工助学岗...\",\"time\":\"2016-06-30 12:23:09\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取学校公告列表
    //      参数： checkcode
    //            pageno（页码，第几页，从第1页开始）
    else if([api isEqualToString:@"getNoticeList"])
    {
        NSData *data = [@"{\"noticelist\":[{\"id\":101,\"title\":\"春游公告1\",\"content\":\"<font size='3' color='red'>This is some text!</font>为方便2012届本专科<img src='http://img1.gtimg.com/news/pics/hv1/224/206/2091/136020029.jpg' />业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如\",\"author\":\"陈老师\",\"datetime\":\"2016-06-29 15:34:18\",\"view\":563,\"isread\":0},{\"id\":102,\"title\":\"春游公告2\",\"content\":\"谁是谁为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如为方便2012届本专科毕业生及时顺利办妥离校手续，现将有关事项安排通知如\",\"author\":\"陈3老师\",\"datetime\":\"2016-06-29 15:24:18\",\"view\":563,\"isread\":1},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0},{\"id\":103,\"title\":\"春游3公告\",\"content\":\"今年春游定于6月20日....\",\"author\":\"陈2老师\",\"datetime\":\"2016-06-29 15:35:18\",\"view\":523,\"isread\":0}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取老师的关联班级，如：（很多地方用到）
    //      校长      －   全校班级
    //      年级组长所管理的年级里的所有班级 ＋ 任职班主任的所有班级 ＋ 任课的所有班级
    //      参数： checkcode
    else if([api isEqualToString:@"getClassList"])
    {
        NSData *data = [@"{\"classlist\":[{\"id\":2,\"name\":\"一年级一班\",\"master\":\"18994567233\"},{\"id\":2,\"name\":\"一年级二班\",\"master\":\"18923467233\"},{\"id\":2,\"name\":\"一年级三班\",\"master\":\"18900567233\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某个老师任课的科目列表（布置家庭作业的时候用到）
    //      参数： checkcode
    else if([api isEqualToString:@"getCourseList"])
    {
        NSData *data = [@"{\"courselist\":[{\"id\":2,\"name\":\"语文\",\"ofclass\":[{\"id\":3,\"name\":\"一年级一斑\"},{\"id\":3,\"name\":\"一年级二斑\"},{\"id\":3,\"name\":\"一年级三斑\"}]},{\"id\":6,\"name\":\"美术\",\"ofclass\":[{\"id\":3,\"name\":\"一年级一斑\"},{\"id\":3,\"name\":\"一年级二斑\"},{\"id\":3,\"name\":\"一年级三斑\"}]}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某个班某天的作业
    //      参数： classid
    //            date（例：20160620）
    else if([api isEqualToString:@"getHomeworkByClass"])
    {
        NSData *data = [@"{\"homeworklist\":[{\"id\":891,\"course\":\"语文\",\"author\":\"18998943580\",\"authorname\":\"韩老师\",\"content\":\"据湖北省民政厅最新通报，截至4日17时统计，全省紧急转移安置30．89万人，需紧急生活救助23．49万人；因灾倒塌和严重损坏房屋13995户3．83万间；农作物受灾面积850千公顷，其中绝收104千公顷；湖北蕲春因暴雨4日发生山体滑坡，造成1人死亡、1人失踪。6月30日以来的强降雨造成湖北79个县市区的957．14万人受灾，38人因灾死亡，17人失踪。\",\"datetime\":\"2016-06-29 15:34:18\",\"isread\":0},{\"id\":892,\"course\":\"数学\",\"author\":\"18825286082\",\"authorname\":\"杨老师\",\"content\":\"今天写数字16. 今天写数字16. 今天写数字16. 今天写数字16. 今天写数字16. 今天写数字16. 今天写数字16. 今天写数字16.\",\"datetime\":\"2016-06-29 15:34:18\",\"isread\":0},{\"id\":893,\"course\":\"物理\",\"author\":\"18271325165\",\"authorname\":\"潘老师\",\"content\":\"今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习.. 今天复习....\",\"datetime\":\"2016-06-29 15:34:18\",\"isread\":1}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某个学生某天的行为记录列表
    //      参数： id（学生编号）
    //            date（例：20160620）
    else if([api isEqualToString:@"getActionByStudent"])
    {
        NSData *data = [@"{\"actiontype\":[{\"value\":1,\"text\":\"进校门\"},{\"value\":2,\"text\":\"出校门\"}],\"actionlist\":[{\"id\":2,\"action\":1,\"name\":\"张三\",\"datetime\":\"2016-06-20 15:45:22\"},{\"id\":3,\"action\":2,\"name\":\"张三\",\"datetime\":\"2016-06-20 15:45:22\"},{\"id\":4,\"action\":1,\"name\":\"张三\",\"datetime\":\"2016-06-20 15:45:22\"},{\"id\":5,\"action\":2,\"name\":\"张三\",\"datetime\":\"2016-06-20 15:45:22\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某班某天的行为记录列表
    //      参数： classid
    //            date（例：20160620）
    else if([api isEqualToString:@"getActionByClass"])
    {
        NSData *data = [@"{\"actiontype\":[{\"value\":1,\"text\":\"进校门\"},{\"value\":2,\"text\":\"出校门\"}],\"actionlist\":[{\"id\":2,\"action\":1,\"name\":\"张三\",\"datetime\":\"2016-06-20 15:45:22\"},{\"id\":3,\"action\":2,\"name\":\"张三\",\"datetime\":\"2016-06-20 15:45:22\"},{\"id\":4,\"action\":1,\"name\":\"张三\",\"datetime\":\"2016-06-20 15:45:22\"},{\"id\":5,\"action\":2,\"name\":\"张三\",\"datetime\":\"2016-06-20 15:45:22\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某个班的考试列表，最近的15条记录
    //      参数： classid
    else if([api isEqualToString:@"getExamByClass"])
    {
        NSData *data = [@"{\"examlist\":[{\"id\":3,\"name\":\"2016年上学期期中考1试\",\"datetime\":\"2016-06-20 15:45:22\",\"isread\":0},{\"id\":4,\"name\":\"2016年上学期期中考试2\",\"datetime\":\"2016-06-20 15:45:22\",\"isread\":0},{\"id\":5,\"name\":\"2016年上学期期中考试3\",\"datetime\":\"2016-06-20 15:45:22\",\"isread\":0}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某个班级某次考试的成绩列表
    //      参数： classid
    //            examid（考试编号）
    else if([api isEqualToString:@"getSoreByExamAndClass"])
    {
        NSData *data = [@"{\"scorelist\":[{\"id\":3,\"studentid\":301,\"student\":\"张三\",\"courseid\":5,\"course\":\"语文\",\"score\":98},{\"id\":4,\"studentid\":302,\"student\":\"李四\",\"courseid\":6,\"course\":\"数学\",\"score\":78},{\"id\":5,\"studentid\":301,\"student\":\"张三\",\"courseid\":15,\"course\":\"体育\",\"score\":86},{\"id\":6,\"studentid\":303,\"student\":\"王武\",\"courseid\":15,\"course\":\"体育\",\"score\":86},{\"id\":6,\"studentid\":306,\"student\":\"周六\",\"courseid\":18,\"course\":\"化学\",\"score\":86}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某个学生某次的考试成绩列表
    //      参数： id（学生编号）
    //            examid（考试编号）
    else if([api isEqualToString:@"getSoreByExamAndStudent"])
    {
        NSData *data = [@"{\"scorelist\":[{\"id\":3,\"studentid\":301,\"student\":\"张三\",\"courseid\":5,\"course\":\"语文\",\"score\":98},{\"id\":4,\"studentid\":301,\"student\":\"张三\",\"courseid\":6,\"course\":\"数学\",\"score\":78},{\"id\":5,\"studentid\":301,\"student\":\"张三\",\"courseid\":15,\"course\":\"体育\",\"score\":86}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某班某天的课程表
    //      参数： classid
    //            date（例：20160620）
    else if([api isEqualToString:@"getCourseTable"])
    {
        NSData *data = [@"{\"coursetable\":[{\"when\":\"上午\",\"list\":[{\"id\":2,\"course\":\"语文\",\"time\":\"8:00-9:00\"},{\"id\":3,\"course\":\"数学\",\"time\":\"9:00-10:00\"},{\"id\":4,\"course\":\"物理\",\"time\":\"10:00-11:00\"},{\"id\":5,\"course\":\"化学\",\"time\":\"11:00-12:00\"}]},{\"when\":\"下午\",\"list\":[{\"id\":6,\"course\":\"语文\",\"time\":\"13:00-14:00\"},{\"id\":7,\"course\":\"数学\",\"time\":\"15:00-16:00\"}]},{\"when\":\"晚上\",\"list\":[{\"id\":6,\"course\":\"语文\",\"time\":\"19:00-20:00\"},{\"id\":7,\"course\":\"数学\",\"time\":\"20:00-21:00\"}]}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取学校咨询信息
    //      参数： pageno（页码，第几页，从第1页开始）
    else if([api isEqualToString:@"getQAList"])
    {
        NSData *data = [@"{\"qalist\":[{\"id\":3,\"qdatetime\":\"2016-06-20 14:25:39\",\"qabout\":\"李四的爸爸\",\"q\":\"今年什么时候放假?\",\"a\":\"怀化境内铁路沪昆线、渝怀线因暴雨实行封锁，焦柳线限速；209国道和320国道怀化境内多处路段因水淹无法通行；该市停电用户达53143户，目前已恢复7501户。怀化市领导干部全员出动指挥和调度防汛救灾工作。\",\"aabout\":\"周校长\",\"adatetime\":\"2016-06-21 18:29:22\"},{\"id\":4,\"qdatetime\":\"2016-06-20 14:25:39\",\"qabout\":\"张三的爸爸\",\"q\":\"据湖北省民政厅最新通报，截至4日17时统计，全省紧急转移安置30．89万人，需紧急生活救助23．49万人；因灾倒塌和严重损坏房屋13995户3．83万间；农作物受灾面积850千公顷，其中绝收104千公顷；湖北蕲春因暴雨4日发生山体滑坡，造成1人死亡、1人失踪。6月30日以来的强降雨造成湖北79个县市区的957．14万人受灾，38人因灾死亡，17人失踪。\",\"a\":\"今年不放假了!\",\"aabout\":\"周校长\",\"adatetime\":\"2016-06-21 18:29:22\"},{\"id\":5,\"qdatetime\":\"2016-06-20 14:25:39\",\"qabout\":\"王武的妈妈\",\"q\":\"7月3日8时至7月4日8时，贵州3县13个乡镇出现特大暴雨，105个乡镇暴雨。强降雨造成铜仁市、黔南州、黔西南州等地10县（区）44个乡镇7．9万人受灾，10人因灾失联，1人死亡。（记者黄浩铭、李斌、向志强、吴小康、明星、陈宇箫、陈俊、李伟、周楠、谭畅、李平、向定杰、黎昌政）\",\"a\":\"7月3日8时至7月4日8时，贵州3县13个乡镇出现特大暴雨，105个乡镇暴雨。强降雨造成铜仁市、黔南州、黔西南州等地10县（区）44个乡镇7．9万人受灾，10人因灾失联，1人死亡。（记者黄浩铭、李斌、向志强、吴小康、明星、陈宇箫、陈俊、李伟、周楠、谭畅、李平、向定杰、黎昌政）!\",\"aabout\":\"周校长\",\"adatetime\":\"2016-06-21 18:29:22\"},{\"id\":6,\"qdatetime\":\"2016-06-20 14:25:39\",\"qabout\":\"李四的爸爸\",\"q\":\"今年什么时候放假?\",\"a\":\"今年不放假了!\",\"aabout\":\"周校长\",\"adatetime\":\"2016-06-21 18:29:22\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取学生食谱
    //            date（例：20160620）
    else if([api isEqualToString:@"getRecipe"])
    {
        NSData *data = [@"{\"date\":\"2016-06-20\",\"recipe\":[{\"id\":3,\"type\":\"早餐\",\"content\":\"小米粥，玉米，粗面馒头\"},{\"id\":4,\"type\":\"午餐\",\"content\":\"小米粥，玉米，粗面馒头,西红柿炒鸡蛋，干煸四季豆，白面馒头。 午点：小馒头，牛奶饼干，鲜牛奶。\"},{\"id\":5,\"type\":\"晚餐\",\"content\":\"小米粥，玉米，粗面馒头\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取老师关联班级的考情情况
    //      参数： checkcode
    //            date（例：20160620）
    else if([api isEqualToString:@"getAttendance"])
    {
        NSData *data = [@"{\"date\":\"2016-06-20\",\"attendance\":[{\"classid\":3,\"classname\":\"一年级一班\",\"absent\":5,\"total\":45},{\"classid\":4,\"classname\":\"一年级二班\",\"absent\":2,\"total\":35},{\"classid\":5,\"classname\":\"一年级三班\",\"absent\":8,\"total\":50},{\"classid\":7,\"classname\":\"二年级二班\",\"absent\":9,\"total\":52}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    // 获取某个班级学生请假列表
    //      参数： classid
    //            date（例：20160620）
    else if([api isEqualToString:@"getAbsentList"])
    {
        NSData *data = [@"{\"date\":\"2016-06-20\",\"absentlist\":[{\"from\":\"2016-06-20 13:30\",\"to\":\"2016-06-21 12:00\",\"classid\":3,\"classname\":\"一年级一班\",\"studentid\":5,\"studentname\":\"章三\"},{\"from\":\"2016-06-20 13:30\",\"to\":\"2016-06-21 12:00\",\"classid\":3,\"classname\":\"一年级一班\",\"studentid\":6,\"studentname\":\"里斯\"},{\"from\":\"2016-06-20 13:30\",\"to\":\"2016-06-21 12:00\",\"classid\":3,\"classname\":\"一年级一班\",\"studentid\":7,\"studentname\":\"王五\"},{\"from\":\"2016-06-20 13:30\",\"to\":\"2016-06-21 12:00\",\"classid\":3,\"classname\":\"一年级一班\",\"studentid\":8,\"studentname\":\"周扒皮\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return jsonDictionary;
    }
    
    return nil;
}

@end
