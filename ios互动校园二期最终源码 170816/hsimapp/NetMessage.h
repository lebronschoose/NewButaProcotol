//
//  NetMessage.h
//  HSEduApp
//
//  Created by han on 14/1/7.
//  Copyright (c) 2014年 han. All rights reserved.
//

#ifndef HSEduApp_NetMessage_h
#define HSEduApp_NetMessage_h

// database return value
#define DRESULT						int

#define D_OK						0
#define D_FAILED					1
#define D_TRUE						2
#define D_FALSE						3
#define D_DBERROR					4
#define D_NOTEXISTUSER				5
#define D_WRONGPASSWORD				6
#define D_DUPUSER                   7
#define D_NOIMSERVER                8
#define D_SERVERSTARTING			9
#define D_NOCHANGEOFGUARDIAN		10
#define D_MISMATCHPERID             11
#define D_DUPFAMILY                 12
#define D_NOTFOUNDCHECKCODE         13
#define D_NOTHASNOGUARDIAN			14

#define D_VERSIONCANUSE             15
#define D_VERSIONUPDATE             16

#define LEN_NODENAME		32
#define LEN_IP				32
#define LEN_ACCOUNT			32
#define LEN_PASSWORD		32
#define LEN_CHECKCODE		32
#define LEN_PERID			16
#define LEN_CLASSID			32
#define LEN_NICKNAME		64
#define LEN_BINDTEXT		256
#define LEN_SIGNTEXT		256
#define LEN_URL				256
#define LEN_EMAIL           50
#define LEN_MOBILE          32
#define LEN_DATE            24

#define WMSG_SIZE           2

//////////////////////////////////////////////////////////////////////////

#define NETMSG_REQLOGINLOGIN			0x2001
#define NETMSG_RESLOGINLOGIN			0x6001
#define NETMSG_REQLOGINIM				0x2002
#define NETMSG_RESLOGINIM				0x6002
//#define NETMSG_REQREGISTER				0x2003
//#define NETMSG_RESREGISTER				0x6003
#define NETMSG_REQUSERDATA              0x2004
#define NETMSG_RESUSERDATA              0x6004
#define NETMSG_REQADDFRIEND             0x2005
#define NETMSG_RESADDFRIEND             0x6005
#define NETMSG_REQUPDATEUSERTEXT        0x2007
#define NETMSG_RESUPDATEUSERTEXT        0x6007
#define NETMSG_REQGROUPUSERLIST         0x2008
#define NETMSG_RESGROUPUSERLIST         0x6008
#define NETMSG_REQBROADCASTNOTIFY       0x2009
#define NETMSG_RESBROADCASTNOTIFY       0x6009
#define NETMSG_RENOTIFY       0x911
#define NETMSG_REQBINDACCOUNT           0x200A
#define NETMSG_RESBINDACCOUNT           0x600A
#define NETMSG_REQTIENAMELIST           0x200B
#define NETMSG_RESTIENAMELIST           0x600B
#define NETMSG_REQRESBINDACCOUNT        0x200C
#define NETMSG_RESRESBINDACCOUNT        0x600C
#define NETMSG_REQSERVICEDATAITEM       0x200D
#define NETMSG_RESSERVICEDATAITEM       0x600D
#define NETMSG_REQSENDDEVICETOKEN       0x200E
#define NETMSG_RESSENDDEVICETOKEN       0x600E
#define NETMSG_REQCLEARBADGENUMBER      0x200F
#define NETMSG_RESCLEARBADGENUMBER      0x600F
#define NETMSG_REQLOGINOUT              0x2010
#define NETMSG_RESLOGINOUT              0x6010
#define NETMSG_REQFRIENDLIST            0x2011
#define NETMSG_RESFRIENDLIST            0x6011
#define NETMSG_REQFORABSENT             0x2012
#define NETMSG_RESFORABSENT             0x6012
#define NETMSG_REQDELETEFRIEND          0x2013
#define NETMSG_RESDELETEFRIEND          0x6013
#define NETMSG_REQPING                  0x2014
#define NETMSG_RESPING                  0x6014
#define NETMSG_REQRESCHATMSG            0x2015
#define NETMSG_REQPUSHDETAIL            0x2016
#define NETMSG_RESPUSHDETAIL            0x6016
#define NETMSG_REQPUSHDETAIL            0x2016
#define NETMSG_RESPUSHDETAIL            0x6016
#define NETMSG_REQPUSHDETAIL            0x2016
#define NETMSG_RESPUSHDETAIL            0x6016
#define NETMSG_REQUPLOADCRASHLOG		0x2017
#define NETMSG_RESUPLOADCRASHLOG		0x6017
#define NETMSG_REQRESBATCHCHATMSG		0x2018
#define NETMSG_RESRESBATCHCHATMSG		0x6018


#define NETMSG_CHATMSG					0x9000
#define NETMSG_DROPCLIENT				0x9001
#define NETMSG_S2C_PUBLICGROUP			0x9002
#define NETMSG_S2C_FRIENDLIST			0x9003
#define NETMSG_RESCHATSEND              0x9004
#define NETMSG_REPLYADDFRIEND           0x9005
#define NETMSG_NOTIFYMSG                0x9006
#define NETMSG_ZIPBATCHMSG              0x9007

#endif


