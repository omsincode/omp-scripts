// --------------------------- Include Guard ----------------------------------
#if defined _admin_commands_included
    #endinput
#endif
#define _admin_commands_included

// ------------------------------ Includes ------------------------------------
#include <a_samp>

// ------------------------------ Defines -------------------------------------
#define COLOR_RED     0xFF0000FF
#define COLOR_GREEN   0x00FF00FF
#define COLOR_YELLOW  0xFFFF00FF
#define COLOR_WHITE   0xFFFFFFFF

// ------------------------------ Stocks -----------------------------------
// ฟังก์ชันช่วยแยกพารามิเตอร์
stock SplitParams(const string[], args[][32], maxArgs = sizeof(args)) {
    new argCount = 0;
    new length = strlen(string);
    new start = 0;
    new end = 0;
    
    while(end < length && argCount < maxArgs) {
        // ข้ามช่องว่าง
        while(end < length && string[end] == ' ') end++;
        start = end;
        
        // หาจุดสิ้นสุดของพารามิเตอร์
        while(end < length && string[end] != ' ') end++;
        
        if(start < end) {
            // จำกัดความยาวสูงสุด 31 ตัวอักษร (เผื่อ 1 ตัวสำหรับ '\0')
            if(end - start > 31) {
                end = start + 31;
            }
            strmid(args[argCount], string, start, end, 32); // คัดลอกเฉพาะช่วงที่กำหนด
            argCount++;
        }
    }
    
    return argCount;
}

// ฟังก์ชันดึงชื่อรถ
stock GetVehicleName(vehicleid, vehiclename[], len) {
    new vNames[212][] = {
        "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perennial", "Sentinel", "Dumper",
        "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule",
        "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington",
        "Bobcat", "Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar",
        "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon",
        "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster",
        "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
        "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van", "Skimmer",
        "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez",
        "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler",
        "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
        "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood",
        "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson",
        "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
        "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt",
        "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900",
        "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck",
        "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
        "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler",
        "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit",
        "Utility", "Nevada", "Yosemite", "Windsor", "Monster A", "Monster B", "Uranus", "Jester",
        "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna",
        "Bandito", "Freight", "Trailer", "Kart", "Mower", "Duneride", "Sweeper", "Broadway",
        "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug",
        "Trailer A", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Trailer B", "Trailer C",
        "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)",
        "Police Car (LVPD)", "Police Ranger", "Picador", "S.W.A.T. Van", "Alpha", "Phoenix",
        "Glendale", "Sadler", "Luggage Trailer A", "Luggage Trailer B", "Stair Trailer", "Boxville",
        "Farm Plow", "Utility Trailer"
    };
    
    vehicleid -= 400; // แปลง ID รถเป็น index ของ array
    if(vehicleid < 0 || vehicleid >= sizeof(vNames)) { // ตรวจสอบ index ให้อยู่ในช่วงที่ถูกต้อง
        format(vehiclename, len, "Unknown");
        return 0;
    }
    
    format(vehiclename, len, "%s", vNames[vehicleid]);
    return 1;
}

// ------------------------------ Short Commands -----------------------------------
// คำสั่งแบบสั้นที่เรียกใช้คำสั่งเต็ม

// คำสั่งแอดมินแบบสั้น /a
CMD:a(playerid, params[]) {
    return ShowAdminMainDialog(playerid);
}

CMD:v(playerid, params[]) {
    return cmd_vehicle(playerid, params);
}

CMD:dv(playerid, params[]) {
    return cmd_deletevehicle(playerid, params);
}

CMD:fix(playerid, params[]) {
    return cmd_repair(playerid, params);
}

// ------------------------------ Fully Commands ----------------------------------
// คำสั่งแบบเต็มพร้อมฟังก์ชันการทำงานทั้งหมด

// คำสั่งแอดมินแบบเต็ม /admin
CMD:admin(playerid, params[]) {
    return ShowAdminMainDialog(playerid);
}

// คำสั่งเสกรถแบบเต็ม /vehicle
CMD:vehicle(playerid, params[]) {
    // เช็คว่าเป็นแอดมินระดับ 1 ขึ้นไปหรือไม่
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    new vehicleid, color1 = -1, color2 = -1;
    
    // ตรวจสอบพารามิเตอร์
    if(strlen(params) == 0) {
        SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /vehicle [รหัสรถ] [สี1] [สี2]");
        SendClientMessage(playerid, COLOR_WHITE, "ตัวอย่าง: /vehicle 411 (/v 411) - เสกรถ Infernus");
        SendClientMessage(playerid, COLOR_WHITE, "ตัวอย่าง: /vehicle 411 0 1 - เสกรถ Infernus สีดำ-ขาว");
        return 1;
    }
    
    new args[3][32];
    new argCount = SplitParams(params, args);
    
    vehicleid = strval(args[0]);
    if(argCount > 1) color1 = strval(args[1]); // สีหลัก
    if(argCount > 2) color2 = strval(args[2]); // สีรอง
    
    // ตรวจสอบรหัสรถว่าถูกต้องหรือไม่ (400-611)
    if(vehicleid < 400 || vehicleid > 611) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: รหัสรถไม่ถูกต้อง! (400-611)");
        return 1;
    }
    
    // ตั้งค่าสีเริ่มต้นถ้าไม่ได้ระบุ
    if(color1 == -1) color1 = random(256); // สุ่มสีหลัก
    if(color2 == -1) color2 = random(256); // สุ่มสีรอง
    
    // ดึงตำแหน่งผู้เล่น
    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    
    // สร้างรถใหม่
    new vehicleobj = CreateVehicle(vehicleid, x + 3.0, y, z, angle, color1, color2, -1);
    
    if(vehicleobj == INVALID_VEHICLE_ID) { // ถ้าสร้างรถไม่สำเร็จ
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: ไม่สามารถสร้างรถได้!");
        return 1;
    }
    
    // ใส่ผู้เล่นเข้ารถ
    PutPlayerInVehicle(playerid, vehicleobj, 0);
    
    // ส่งข้อความแจ้งเตือน
    new message[128], vehiclename[32];
    GetVehicleName(vehicleid, vehiclename, sizeof(vehiclename));
    format(message, sizeof(message), "เสกรถ %s (ID: %d) สำเร็จ! สี: %d-%d", vehiclename, vehicleid, color1, color2);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    // Log การใช้คำสั่ง
    new logmsg[256];
    format(logmsg, sizeof(logmsg), "[ADMIN] %s ได้เสกรถ %s (ID: %d)", getplayername(playerid), vehiclename, vehicleid);
    print(logmsg);
    
    return 1;
}

// คำสั่งลบรถแบบเต็ม /deletevehicle
CMD:deletevehicle(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    if(!IsPlayerInAnyVehicle(playerid)) { // ตรวจสอบว่าผู้เล่นอยู่ในรถหรือไม่
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณต้องอยู่ในรถเพื่อลบรถ!");
        return 1;
    }
    
    new vehicleobj = GetPlayerVehicleID(playerid);
    new vehiclemodel = GetVehicleModel(vehicleobj);
    new vehiclename[32];
    GetVehicleName(vehiclemodel, vehiclename, sizeof(vehiclename));
    
    DestroyVehicle(vehicleobj); // ลบรถ
    
    new message[128];
    format(message, sizeof(message), "ลบรถ %s สำเร็จ!", vehiclename);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    return 1;
}

// คำสั่งซ่อมรถแบบเต็ม /repair
CMD:repair(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    if(!IsPlayerInAnyVehicle(playerid)) { // ตรวจสอบว่าผู้เล่นอยู่ในรถหรือไม่
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณต้องอยู่ในรถเพื่อซ่อมรถ!");
        return 1;
    }
    
    new vehicleobj = GetPlayerVehicleID(playerid);
    RepairVehicle(vehicleobj); // ซ่อมรถ
    
    SendClientMessage(playerid, COLOR_GREEN, "ซ่อมรถเรียบร้อยแล้ว!");
    
    return 1;
}

