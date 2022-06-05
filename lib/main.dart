import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main(){
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context) => const Homepage(),
      },
    );
  }
}


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  Color primaryColor = const Color(0xff15202B);

  @override
  initState(){
    super.initState();
    permissionsList.forEach((e) async {
      if(await e.permission.isGranted){
        e.status = "Granted";
      }else if(await e.permission.isDenied){
        e.status = "Denied";
      }else if(await e.permission.isPermanentlyDenied){
        e.status = "Fully Denied";
      }else if(await e.permission.isLimited){
        e.status = "Limited";
      }else if(await e.permission.isRestricted){
        e.status = "Restricted";
      }else{
        e.status = "Unknown";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: const Text("Permission Handler"),
          actions: [
            PopupMenuButton(
                onSelected: (_) async {

                },
                itemBuilder: (BuildContext context){

                  return permissionsList.map(
                          (e) => PopupMenuItem(
                              child: GestureDetector(
                                onTap: ()async{
                                  await openAppSettings();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(e.iconData, color: primaryColor,),
                                    Text(e.status.toString()),
                                  ],
                                ),
                              )
                          )
                  ).toList();
                }
            ),
          ]
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          physics: const BouncingScrollPhysics(),
          children: permissionsList.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: OutlinedButton(
                        onPressed: ()async{
                          await e.permission.request();
                          if(await e.permission.isGranted){
                            e.status = "Granted";
                            Fluttertoast.showToast(
                                msg: "Permission Granted",
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else if(await e.permission.isDenied){
                            e.status = "Denied";
                            Fluttertoast.showToast(
                                msg: "Permission Denied",
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else if(await e.permission.isPermanentlyDenied){
                            e.status = "Fully Denied";
                            Fluttertoast.showToast(
                                msg: "Permission Permanently Denied",
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else if(await e.permission.isLimited){
                            e.status = "Limited";
                            Fluttertoast.showToast(
                                msg: "Limited Permission",
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else if(await e.permission.isRestricted){
                            e.status = "Restricted";
                            Fluttertoast.showToast(
                                msg: "Restricted Permission",
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          primary: primaryColor,
                          fixedSize: Size(MediaQuery.of(context).size.width*0.9, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: primaryColor,width: 1),
                          textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.permissionName,),
                            Icon(e.iconData),
                          ],
                        ),
                    ),
                  ),).toList()
        )
      ),
    );
  }
}


class AppPermission{
  String permissionName;
  IconData iconData;
  Permission permission;
  String status;

  AppPermission({
    this.status = "Unknown",
    required this.permissionName,
    required this.permission,
    required this.iconData,
  });
}

List<AppPermission> permissionsList = <AppPermission>[
  AppPermission(permissionName: "Camera Permission", permission: Permission.camera, iconData: Icons.camera_alt_outlined),
  AppPermission(permissionName: "Bluetooth Permission", permission: Permission.bluetooth, iconData: Icons.bluetooth),
  AppPermission(permissionName: "Calender Permission", permission: Permission.calendar, iconData: Icons.calendar_today_rounded),
  AppPermission(permissionName: "Contacts Permission", permission: Permission.contacts, iconData: Icons.contact_page_outlined),
  AppPermission(permissionName: "Location Permission", permission: Permission.location, iconData: Icons.location_on_outlined),
  AppPermission(permissionName: "Microphone Permission", permission: Permission.microphone, iconData: Icons.mic_none_rounded),
  AppPermission(permissionName: "Notification Permission", permission: Permission.notification, iconData: Icons.notifications_active_outlined),
  AppPermission(permissionName: "Phone Permission", permission: Permission.phone, iconData: Icons.phone_rounded),
  AppPermission(permissionName: "Storage Permission", permission: Permission.storage, iconData: Icons.storage),
  AppPermission(permissionName: "Photos Permission", permission: Permission.photos, iconData: Icons.photo),
  AppPermission(permissionName: "Sensors Permission", permission: Permission.sensors, iconData: Icons.sensors_outlined),
  AppPermission(permissionName: "SMS Permission", permission: Permission.sms, iconData: Icons.sms_outlined),
  AppPermission(permissionName: "Reminder Permission", permission: Permission.reminders, iconData: Icons.notifications),
  AppPermission(permissionName: "Bluetooth Connect Permission", permission: Permission.bluetoothConnect, iconData: Icons.bluetooth_audio),
];
