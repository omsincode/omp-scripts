// --------------------------- Include Guard ----------------------------------
#if defined _dialog_systems_included
    #endinput
#endif
#define _dialog_systems_included

// ------------------------------ Includes ------------------------------------
#include "systems/login_systems.pwn"

// ------------------------------ Dialog IDs ----------------------------------
#define DIALOG_ADMIN_MAIN           100
#define DIALOG_ADMIN_VEHICLE        101
#define DIALOG_ADMIN_TELEPORT       102
#define DIALOG_ADMIN_PLAYER_MANAGE  103
#define DIALOG_ADMIN_PLAYER_LIST    104
#define DIALOG_ADMIN_PLAYER_INFO    105
#define DIALOG_ADMIN_SET_HEALTH     106
#define DIALOG_ADMIN_MONEY_MANAGE   107
#define DIALOG_ADMIN_MONEY_GIVE     108
#define DIALOG_ADMIN_MONEY_TAKE     109
#define DIALOG_ADMIN_KICK_PLAYER    110
#define DIALOG_ADMIN_BAN_PLAYER     111

// --------------------------- Admin Dialog Functions -------------------------

// แสดง Dialog หลักของแอดมิน
stock ShowAdminMainDialog(playerid) {
    if(!IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, 0xFF0000AA, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 0;
    }
    
    new dialog_content[512];
    strcat(dialog_content, "?? Vehicle Management\n");
    strcat(dialog_content, "?? Teleport Options\n");
    strcat(dialog_content, "?? Player Management\n");
    strcat(dialog_content, "?? Server Settings");
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_MAIN, DIALOG_STYLE_LIST,
        "?? Admin Control Panel", dialog_content, "เลือก", "ปิด");
    return 1;
}

// แสดง Dialog Vehicle Management
stock ShowVehicleManagementDialog(playerid) {
    new dialog_content[512];
    strcat(dialog_content, "?? Spawn Vehicle\n");
    strcat(dialog_content, "??? Delete Vehicle\n");
    strcat(dialog_content, "?? Repair Vehicle\n");
    strcat(dialog_content, "?? Change Vehicle Color\n");
    strcat(dialog_content, "?? Vehicle Information");
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE, DIALOG_STYLE_LIST,
        "?? Vehicle Management", dialog_content, "เลือก", "กลับ");
    return 1;
}

// แสดง Dialog Teleport Options
stock ShowTeleportDialog(playerid) {
    new dialog_content[512];
    strcat(dialog_content, "??? Los Santos\n");
    strcat(dialog_content, "?? San Fierro\n");
    strcat(dialog_content, "?? Las Venturas\n");
    strcat(dialog_content, "??? Custom Locations");
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_TELEPORT, DIALOG_STYLE_LIST,
        "?? Teleport Menu", dialog_content, "เลือก", "กลับ");
    return 1;
}

// แสดง Dialog Player Management
stock ShowPlayerManagementDialog(playerid) {
    new dialog_content[512];
    strcat(dialog_content, "?? View Player Info\n");
    strcat(dialog_content, "? Set Player Health\n");
    strcat(dialog_content, "?? Give/Take Money\n");
    strcat(dialog_content, "?? Kick Player\n");
    strcat(dialog_content, "?? Ban Player");
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_PLAYER_MANAGE, DIALOG_STYLE_LIST,
        "?? Player Management", dialog_content, "เลือก", "กลับ");
    return 1;
}

// แสดง Dialog รายชื่อผู้เล่นออนไลน์
stock ShowPlayerListDialog(playerid, const action[]) {
    new dialog_content[2048], temp_string[64], count = 0;
    
    strcat(dialog_content, "ID\tชื่อผู้เล่น\tเลเวล\tแอดมิน\n");
    
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            new playername[MAX_PLAYER_NAME], admintext[16];
            GetPlayerName(i, playername, sizeof(playername));
            
            if(IsPlayerLoggedIn(i) && PlayerIntData[i][AdminLevel] > 0) {
                format(admintext, sizeof(admintext), "Admin %d", PlayerIntData[i][AdminLevel]);
            } else {
                format(admintext, sizeof(admintext), "ผู้เล่น");
            }
            
            new level = IsPlayerLoggedIn(i) ? PlayerIntData[i][Level] : 0;
            format(temp_string, sizeof(temp_string), "%d\t%s\t%d\t%s\n", i, playername, level, admintext);
            strcat(dialog_content, temp_string);
            count++;
        }
    }
    
    if(count == 0) {
        SendClientMessage(playerid, 0xFF0000AA, "? ไม่มีผู้เล่นออนไลน์!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new title[64];
    format(title, sizeof(title), "?? เลือกผู้เล่น - %s", action);
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_PLAYER_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        title, dialog_content, "เลือก", "กลับ");
    return 1;
}

// แสดงข้อมูลผู้เล่นรายละเอียด
stock ShowPlayerInfoDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นนี้ไม่ออนไลน์!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[1024];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    new Float:health, Float:armour, Float:x, Float:y, Float:z;
    GetPlayerHealth(targetid, health);
    GetPlayerArmour(targetid, armour);
    GetPlayerPos(targetid, x, y, z);
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? ข้อมูลผู้เล่น: {FFFF00}%s {FFFFFF}(ID: %d)\n\n" \
        "{00FF00}? สถานะการเข้าสู่ระบบ: {FFFFFF}%s\n" \
        "{00FF00}? เลเวล: {FFFFFF}%d\n" \
        "{00FF00}? ประสบการณ์: {FFFFFF}%d XP\n" \
        "{00FF00}? เงิน: {FFFFFF}$%s\n" \
        "{00FF00}? พลังชีวิต: {FFFFFF}%.1f/100\n" \
        "{00FF00}? เกราะ: {FFFFFF}%.1f/100\n" \
        "{00FF00}? ระดับแอดมิน: {FFFFFF}%d\n" \
        "{00FF00}? สกิน: {FFFFFF}%d\n" \
        "{00FF00}? ตำแหน่ง: {FFFFFF}%.2f, %.2f, %.2f\n" \
        "{00FF00}? Ping: {FFFFFF}%d ms",
        playername, targetid,
        IsPlayerLoggedIn(targetid) ? "เข้าสู่ระบบแล้ว" : "ยังไม่เข้าสู่ระบบ",
        IsPlayerLoggedIn(targetid) ? PlayerIntData[targetid][Level] : 0,
        IsPlayerLoggedIn(targetid) ? PlayerIntData[targetid][XP] : 0,
        FormatNumber(GetPlayerMoney(targetid)),
        health, armour,
        IsPlayerLoggedIn(targetid) ? PlayerIntData[targetid][AdminLevel] : 0,
        GetPlayerSkin(targetid),
        x, y, z,
        GetPlayerPing(targetid)
    );
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_PLAYER_INFO, DIALOG_STYLE_MSGBOX,
        "?? ข้อมูลผู้เล่น", dialog_content, "ปิด", "");
    return 1;
}

// แสดง Dialog ตั้งค่าพลังชีวิต
stock ShowSetHealthDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นนี้ไม่ออนไลน์!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[256];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    new Float:current_health;
    GetPlayerHealth(targetid, current_health);
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? ตั้งค่าพลังชีวิตสำหรับ: {FFFF00}%s\n\n" \
        "{00FF00}? พลังชีวิตปัจจุบัน: {FFFFFF}%.1f/100\n\n" \
        "{FFFFFF}กรุณาใส่ค่าพลังชีวิตใหม่ (1-100):",
        playername, current_health
    );
    
    SetPVarInt(playerid, "AdminTargetID", targetid);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_SET_HEALTH, DIALOG_STYLE_INPUT,
        "?? ตั้งค่าพลังชีวิต", dialog_content, "ตั้งค่า", "ยกเลิก");
    return 1;
}

// แสดง Dialog จัดการเงิน
stock ShowMoneyManagementDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นนี้ไม่ออนไลน์!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[512];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    new current_money = GetPlayerMoney(targetid);
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? จัดการเงินสำหรับ: {FFFF00}%s\n\n" \
        "{00FF00}? เงินปัจจุบัน: {FFFFFF}$%s\n\n" \
        "{FFFFFF}?? ให้เงิน\n" \
        "{FFFFFF}?? หักเงิน",
        playername, FormatNumber(current_money)
    );
    
    SetPVarInt(playerid, "AdminTargetID", targetid);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_MONEY_MANAGE, DIALOG_STYLE_LIST,
        "?? จัดการเงิน", dialog_content, "เลือก", "ยกเลิก");
    return 1;
}

// แสดง Dialog เตะผู้เล่น
stock ShowKickPlayerDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นนี้ไม่ออนไลน์!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[512];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? เตะผู้เล่น: {FFFF00}%s\n\n" \
        "{FF6666}? การกระทำนี้จะทำให้ผู้เล่นออกจากเซิร์ฟเวอร์\n\n" \
        "{FFFFFF}กรุณาใส่เหตุผลการเตะ:",
        playername
    );
    
    SetPVarInt(playerid, "AdminTargetID", targetid);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_KICK_PLAYER, DIALOG_STYLE_INPUT,
        "?? เตะผู้เล่น", dialog_content, "เตะ", "ยกเลิก");
    return 1;
}

// แสดง Dialog แบนผู้เล่น
stock ShowBanPlayerDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นนี้ไม่ออนไลน์!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[512];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? แบนผู้เล่น: {FFFF00}%s\n\n" \
        "{FF3333}? การกระทำนี้จะห้ามผู้เล่นเข้าเซิร์ฟเวอร์\n\n" \
        "{FFFFFF}กรุณาใส่เหตุผลการแบน:",
        playername
    );
    
    SetPVarInt(playerid, "AdminTargetID", targetid);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_BAN_PLAYER, DIALOG_STYLE_INPUT,
        "?? แบนผู้เล่น", dialog_content, "แบน", "ยกเลิก");
    return 1;
}

// ฟังก์ชันช่วยจัดรูปแบบตัวเลข
stock FormatNumber(number) {
    new str[32];
    format(str, sizeof(str), "%d", number);
    return str;
}

// ฟังก์ชันช่วยหา ID ผู้เล่นจาก listitem
stock GetPlayerIDFromListitem(listitem) {
    new count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(count == listitem) {
                return i;
            }
            count++;
        }
    }
    return INVALID_PLAYER_ID;
}

// ฟังก์ชันเตะผู้เล่นแบบล่าช้า
forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid) {
    if(IsPlayerConnected(playerid)) {
        Kick(playerid);
    }
    return 1;
}

// --------------------------- Dialog Systems ---------------------------------
// จัดการ Dialog ทั้งหมดในที่เดียว แบบ switch statement แบบเดิม

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        // ==================== LOGIN SYSTEM DIALOGS ====================
        case DIALOG_LOGIN: {
            if(!response) { // กดปุ่ม "ยกเลิก"
                Kick(playerid);
                return 1;
            }
            // กดปุ่ม "เข้าสู่ระบบ"
            if(strlen(inputtext) < 1) {
                SendClientMessage(playerid, -1, "{FF0000}กรุณาใส่รหัสผ่าน!");
                return ShowLoginDialog(playerid);
            }
            LoginPlayer(playerid, inputtext);
            return 1;
        }
        
        case DIALOG_REGISTER: {
            if(!response) { // กดปุ่ม "ยกเลิก"
                Kick(playerid);
                return 1;
            }
            // กดปุ่ม "สมัครสมาชิก"
            if(strlen(inputtext) < 1) {
                SendClientMessage(playerid, -1, "{FF0000}กรุณาใส่รหัสผ่าน!");
                return ShowRegisterDialog(playerid);
            }
            RegisterPlayer(playerid, inputtext);
            return 1;
        }
        
        // ==================== ADMIN SYSTEM DIALOGS ====================
        case DIALOG_ADMIN_MAIN: {
            if(!response) return 1; // ปิด dialog
            
            switch(listitem) {
                case 0: ShowVehicleManagementDialog(playerid); // Vehicle Management
                case 1: ShowTeleportDialog(playerid);          // Teleport Options  
                case 2: ShowPlayerManagementDialog(playerid);  // Player Management
                case 3: {
                    SendClientMessage(playerid, 0xFFFF00AA, "?? Server Settings - Coming Soon!");
                }
            }
            return 1;
        }
        
        case DIALOG_ADMIN_VEHICLE: {
            if(!response) {
                ShowAdminMainDialog(playerid); // กลับไปหน้าหลัก
                return 1;
            }
            
            switch(listitem) {
                case 0: { // Spawn Vehicle
                    SendClientMessage(playerid, 0x00FF00AA, "?? ใช้คำสั่ง: /v [รหัสรถ] [สี1] [สี2]");
                    SendClientMessage(playerid, 0xFFFFFFAA, "ตัวอย่าง: /v 411 0 1");
                }
                case 1: { // Delete Vehicle
                    SendClientMessage(playerid, 0x00FF00AA, "?? ใช้คำสั่ง: /dv หรือ /deletevehicle");
                }
                case 2: { // Repair Vehicle
                    SendClientMessage(playerid, 0x00FF00AA, "?? ใช้คำสั่ง: /fix หรือ /repair");
                }
                case 3: { // Change Color
                    SendClientMessage(playerid, 0xFFFF00AA, "?? Change Vehicle Color - Coming Soon!");
                }
                case 4: { // Vehicle Info
                    if(IsPlayerInAnyVehicle(playerid)) {
                        new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
                        new vehiclename[32];
                        GetVehicleName(vehiclemodel, vehiclename, sizeof(vehiclename));
                        
                        new info_msg[128];
                        format(info_msg, sizeof(info_msg), "?? รถที่คุณนั่งอยู่: %s (ID: %d)", vehiclename, vehiclemodel);
                        SendClientMessage(playerid, 0x00DDFFAA, info_msg);
                    } else {
                        SendClientMessage(playerid, 0xFF0000AA, "? คุณไม่ได้อยู่ในรถ!");
                    }
                }
            }
            return 1;
        }
        
        case DIALOG_ADMIN_TELEPORT: {
            if(!response) {
                ShowAdminMainDialog(playerid); // กลับไปหน้าหลัก
                return 1;
            }
            
            switch(listitem) {
                case 0: { // Los Santos
                    SetPlayerPos(playerid, 1172.02, -1323.89, 15.00);
                    SendClientMessage(playerid, 0x00FF00AA, "?? เทเลพอร์ตไป Los Santos แล้ว!");
                }
                case 1: { // San Fierro
                    SetPlayerPos(playerid, -2026.65, 156.66, 29.04);
                    SendClientMessage(playerid, 0x00FF00AA, "?? เทเลพอร์ตไป San Fierro แล้ว!");
                }
                case 2: { // Las Venturas
                    SetPlayerPos(playerid, 2495.05, 1666.84, 11.04);
                    SendClientMessage(playerid, 0x00FF00AA, "?? เทเลพอร์ตไป Las Venturas แล้ว!");
                }
                case 3: { // Custom Locations
                    SendClientMessage(playerid, 0xFFFF00AA, "?? Custom Locations - Coming Soon!");
                }
            }
            return 1;
        }
        
        case DIALOG_ADMIN_PLAYER_MANAGE: {
            if(!response) {
                ShowAdminMainDialog(playerid); // กลับไปหน้าหลัก
                return 1;
            }
            
            switch(listitem) {
                case 0: { // View Player Info
                    SetPVarString(playerid, "AdminAction", "info");
                    ShowPlayerListDialog(playerid, "ดูข้อมูล");
                }
                case 1: { // Set Health
                    SetPVarString(playerid, "AdminAction", "set_health");
                    ShowPlayerListDialog(playerid, "ตั้งค่าพลังชีวิต");
                }
                case 2: { // Give/Take Money
                    SetPVarString(playerid, "AdminAction", "money");
                    ShowPlayerListDialog(playerid, "จัดการเงิน");
                }
                case 3: { // Kick Player
                    SetPVarString(playerid, "AdminAction", "kick");
                    ShowPlayerListDialog(playerid, "เตะผู้เล่น");
                }
                case 4: { // Ban Player
                    SetPVarString(playerid, "AdminAction", "ban");
                    ShowPlayerListDialog(playerid, "แบนผู้เล่น");
                }
            }
            return 1;
        }
        
        // จัดการรายชื่อผู้เล่น
        case DIALOG_ADMIN_PLAYER_LIST: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPlayerIDFromListitem(listitem);
            if(targetid == INVALID_PLAYER_ID) {
                SendClientMessage(playerid, 0xFF0000AA, "? ไม่พบผู้เล่นที่เลือก!");
                ShowPlayerListDialog(playerid, "เลือกผู้เล่น");
                return 1;
            }
            
            // ตรวจสอบว่า admin ที่เรียกใช้กำลังทำอะไรอยู่
            new action[32];
            GetPVarString(playerid, "AdminAction", action, sizeof(action));
            
            if(strcmp(action, "set_health", true) == 0) {
                ShowSetHealthDialog(playerid, targetid);
            } else if(strcmp(action, "money", true) == 0) {
                ShowMoneyManagementDialog(playerid, targetid);
            } else if(strcmp(action, "kick", true) == 0) {
                ShowKickPlayerDialog(playerid, targetid);
            } else if(strcmp(action, "ban", true) == 0) {
                ShowBanPlayerDialog(playerid, targetid);
            } else {
                ShowPlayerInfoDialog(playerid, targetid);
            }
            return 1;
        }
        
        // จัดการตั้งค่าพลังชีวิต
        case DIALOG_ADMIN_SET_HEALTH: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นไม่ออนไลน์!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new health = strval(inputtext);
            if(health < 1 || health > 100) {
                SendClientMessage(playerid, 0xFF0000AA, "? ค่าพลังชีวิตต้องอยู่ระหว่าง 1-100!");
                return ShowSetHealthDialog(playerid, targetid);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            SetPlayerHealth(targetid, float(health));
            
            new msg[128];
            format(msg, sizeof(msg), "? ตั้งค่าพลังชีวิตของ %s เป็น %d แล้ว", playername, health);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            format(msg, sizeof(msg), "?? Admin %s ได้ตั้งค่าพลังชีวิตของคุณเป็น %d", adminname, health);
            SendClientMessage(targetid, 0x00DDFFAA, msg);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
        
        // จัดการเงิน
        case DIALOG_ADMIN_MONEY_MANAGE: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นไม่ออนไลน์!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new playername[MAX_PLAYER_NAME], dialog_content[256];
            GetPlayerName(targetid, playername, sizeof(playername));
            
            switch(listitem) {
                case 0: { // ให้เงิน
                    format(dialog_content, sizeof(dialog_content),
                        "{FFFFFF}?? ให้เงินสำหรับ: {FFFF00}%s\n\n" \
                        "{00FF00}? เงินปัจจุบัน: {FFFFFF}$%s\n\n" \
                        "{FFFFFF}กรุณาใส่จำนวนเงินที่จะให้:",
                        playername, FormatNumber(GetPlayerMoney(targetid))
                    );
                    
                    ShowPlayerDialog(playerid, DIALOG_ADMIN_MONEY_GIVE, DIALOG_STYLE_INPUT,
                        "?? ให้เงิน", dialog_content, "ให้เงิน", "ยกเลิก");
                }
                case 1: { // หักเงิน
                    format(dialog_content, sizeof(dialog_content),
                        "{FFFFFF}?? หักเงินสำหรับ: {FFFF00}%s\n\n" \
                        "{00FF00}? เงินปัจจุบัน: {FFFFFF}$%s\n\n" \
                        "{FFFFFF}กรุณาใส่จำนวนเงินที่จะหัก:",
                        playername, FormatNumber(GetPlayerMoney(targetid))
                    );
                    
                    ShowPlayerDialog(playerid, DIALOG_ADMIN_MONEY_TAKE, DIALOG_STYLE_INPUT,
                        "?? หักเงิน", dialog_content, "หักเงิน", "ยกเลิก");
                }
            }
            return 1;
        }
        
        // ให้เงิน
        case DIALOG_ADMIN_MONEY_GIVE: {
            if(!response) {
                new targetid = GetPVarInt(playerid, "AdminTargetID");
                ShowMoneyManagementDialog(playerid, targetid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นไม่ออนไลน์!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new amount = strval(inputtext);
            if(amount < 1) {
                SendClientMessage(playerid, 0xFF0000AA, "? จำนวนเงินต้องมากกว่า 0!");
                return ShowMoneyManagementDialog(playerid, targetid);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            GivePlayerMoney(targetid, amount);
            
            new msg[128];
            format(msg, sizeof(msg), "? ให้เงิน $%s แก่ %s แล้ว", FormatNumber(amount), playername);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            format(msg, sizeof(msg), "?? Admin %s ได้ให้เงิน $%s แก่คุณ", adminname, FormatNumber(amount));
            SendClientMessage(targetid, 0x00DDFFAA, msg);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
        
        // หักเงิน
        case DIALOG_ADMIN_MONEY_TAKE: {
            if(!response) {
                new targetid = GetPVarInt(playerid, "AdminTargetID");
                ShowMoneyManagementDialog(playerid, targetid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นไม่ออนไลน์!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new amount = strval(inputtext);
            if(amount < 1) {
                SendClientMessage(playerid, 0xFF0000AA, "? จำนวนเงินต้องมากกว่า 0!");
                return ShowMoneyManagementDialog(playerid, targetid);
            }
            
            new current_money = GetPlayerMoney(targetid);
            if(amount > current_money) {
                SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นไม่มีเงินเพียงพอ!");
                return ShowMoneyManagementDialog(playerid, targetid);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            GivePlayerMoney(targetid, -amount);
            
            new msg[128];
            format(msg, sizeof(msg), "? หักเงิน $%s จาก %s แล้ว", FormatNumber(amount), playername);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            format(msg, sizeof(msg), "?? Admin %s ได้หักเงิน $%s จากคุณ", adminname, FormatNumber(amount));
            SendClientMessage(targetid, 0xFFBB00AA, msg);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
        
        // เตะผู้เล่น
        case DIALOG_ADMIN_KICK_PLAYER: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นไม่ออนไลน์!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new reason[128];
            if(strlen(inputtext) < 1) {
                format(reason, sizeof(reason), "ไม่ระบุเหตุผล");
            } else {
                format(reason, sizeof(reason), "%s", inputtext);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            new msg[256];
            format(msg, sizeof(msg), "?? %s ถูกเตะโดย Admin %s | เหตุผล: %s", playername, adminname, reason);
            SendClientMessageToAll(0xFF6666AA, msg);
            
            format(msg, sizeof(msg), "?? คุณถูกเตะจากเซิร์ฟเวอร์โดย Admin %s | เหตุผล: %s", adminname, reason);
            SendClientMessage(targetid, 0xFF6666AA, msg);
            
            format(msg, sizeof(msg), "? เตะ %s ออกจากเซิร์ฟเวอร์แล้ว | เหตุผล: %s", playername, reason);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            SetTimerEx("KickPlayerDelayed", 1000, false, "i", targetid);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
        
        // แบนผู้เล่น
        case DIALOG_ADMIN_BAN_PLAYER: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ผู้เล่นไม่ออนไลน์!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new reason[128];
            if(strlen(inputtext) < 1) {
                format(reason, sizeof(reason), "ไม่ระบุเหตุผล");
            } else {
                format(reason, sizeof(reason), "%s", inputtext);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            // บันทึกข้อมูลการแบนลงไฟล์ bans.json (ถ้ามี) หรือ ban IP
            new playerip[16];
            GetPlayerIp(targetid, playerip, sizeof(playerip));
            
            new msg[256];
            format(msg, sizeof(msg), "?? %s ถูกแบนโดย Admin %s | เหตุผล: %s", playername, adminname, reason);
            SendClientMessageToAll(0xFF3333AA, msg);
            
            format(msg, sizeof(msg), "?? คุณถูกแบนจากเซิร์ฟเวอร์โดย Admin %s | เหตุผล: %s", adminname, reason);
            SendClientMessage(targetid, 0xFF3333AA, msg);
            
            format(msg, sizeof(msg), "? แบน %s (IP: %s) แล้ว | เหตุผล: %s", playername, playerip, reason);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            // แบน IP
            new ban_cmd[64];
            format(ban_cmd, sizeof(ban_cmd), "banip %s", playerip);
            SendRconCommand(ban_cmd);
            
            SetTimerEx("KickPlayerDelayed", 1500, false, "i", targetid);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
    }
    
    return 0; // ไม่พบ dialog ที่ตรงกัน
}
