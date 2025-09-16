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

// �ʴ� Dialog ��ѡ�ͧ�ʹ�Թ
stock ShowAdminMainDialog(playerid) {
    if(!IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, 0xFF0000AA, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 0;
    }
    
    new dialog_content[512];
    strcat(dialog_content, "?? Vehicle Management\n");
    strcat(dialog_content, "?? Teleport Options\n");
    strcat(dialog_content, "?? Player Management\n");
    strcat(dialog_content, "?? Server Settings");
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_MAIN, DIALOG_STYLE_LIST,
        "?? Admin Control Panel", dialog_content, "���͡", "�Դ");
    return 1;
}

// �ʴ� Dialog Vehicle Management
stock ShowVehicleManagementDialog(playerid) {
    new dialog_content[512];
    strcat(dialog_content, "?? Spawn Vehicle\n");
    strcat(dialog_content, "??? Delete Vehicle\n");
    strcat(dialog_content, "?? Repair Vehicle\n");
    strcat(dialog_content, "?? Change Vehicle Color\n");
    strcat(dialog_content, "?? Vehicle Information");
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE, DIALOG_STYLE_LIST,
        "?? Vehicle Management", dialog_content, "���͡", "��Ѻ");
    return 1;
}

// �ʴ� Dialog Teleport Options
stock ShowTeleportDialog(playerid) {
    new dialog_content[512];
    strcat(dialog_content, "??? Los Santos\n");
    strcat(dialog_content, "?? San Fierro\n");
    strcat(dialog_content, "?? Las Venturas\n");
    strcat(dialog_content, "??? Custom Locations");
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_TELEPORT, DIALOG_STYLE_LIST,
        "?? Teleport Menu", dialog_content, "���͡", "��Ѻ");
    return 1;
}

// �ʴ� Dialog Player Management
stock ShowPlayerManagementDialog(playerid) {
    new dialog_content[512];
    strcat(dialog_content, "?? View Player Info\n");
    strcat(dialog_content, "? Set Player Health\n");
    strcat(dialog_content, "?? Give/Take Money\n");
    strcat(dialog_content, "?? Kick Player\n");
    strcat(dialog_content, "?? Ban Player");
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_PLAYER_MANAGE, DIALOG_STYLE_LIST,
        "?? Player Management", dialog_content, "���͡", "��Ѻ");
    return 1;
}

// �ʴ� Dialog ��ª��ͼ������͹�Ź�
stock ShowPlayerListDialog(playerid, const action[]) {
    new dialog_content[2048], temp_string[64], count = 0;
    
    strcat(dialog_content, "ID\t���ͼ�����\t�����\t�ʹ�Թ\n");
    
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            new playername[MAX_PLAYER_NAME], admintext[16];
            GetPlayerName(i, playername, sizeof(playername));
            
            if(IsPlayerLoggedIn(i) && PlayerIntData[i][AdminLevel] > 0) {
                format(admintext, sizeof(admintext), "Admin %d", PlayerIntData[i][AdminLevel]);
            } else {
                format(admintext, sizeof(admintext), "������");
            }
            
            new level = IsPlayerLoggedIn(i) ? PlayerIntData[i][Level] : 0;
            format(temp_string, sizeof(temp_string), "%d\t%s\t%d\t%s\n", i, playername, level, admintext);
            strcat(dialog_content, temp_string);
            count++;
        }
    }
    
    if(count == 0) {
        SendClientMessage(playerid, 0xFF0000AA, "? ����ռ������͹�Ź�!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new title[64];
    format(title, sizeof(title), "?? ���͡������ - %s", action);
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_PLAYER_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        title, dialog_content, "���͡", "��Ѻ");
    return 1;
}

// �ʴ������ż�������������´
stock ShowPlayerInfoDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? �����蹹������͹�Ź�!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[1024];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    new Float:health, Float:armour, Float:x, Float:y, Float:z;
    GetPlayerHealth(targetid, health);
    GetPlayerArmour(targetid, armour);
    GetPlayerPos(targetid, x, y, z);
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? �����ż�����: {FFFF00}%s {FFFFFF}(ID: %d)\n\n" \
        "{00FF00}? ʶҹС���������к�: {FFFFFF}%s\n" \
        "{00FF00}? �����: {FFFFFF}%d\n" \
        "{00FF00}? ���ʺ��ó�: {FFFFFF}%d XP\n" \
        "{00FF00}? �Թ: {FFFFFF}$%s\n" \
        "{00FF00}? ��ѧ���Ե: {FFFFFF}%.1f/100\n" \
        "{00FF00}? ����: {FFFFFF}%.1f/100\n" \
        "{00FF00}? �дѺ�ʹ�Թ: {FFFFFF}%d\n" \
        "{00FF00}? ʡԹ: {FFFFFF}%d\n" \
        "{00FF00}? ���˹�: {FFFFFF}%.2f, %.2f, %.2f\n" \
        "{00FF00}? Ping: {FFFFFF}%d ms",
        playername, targetid,
        IsPlayerLoggedIn(targetid) ? "�������к�����" : "�ѧ����������к�",
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
        "?? �����ż�����", dialog_content, "�Դ", "");
    return 1;
}

// �ʴ� Dialog ��駤�Ҿ�ѧ���Ե
stock ShowSetHealthDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? �����蹹������͹�Ź�!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[256];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    new Float:current_health;
    GetPlayerHealth(targetid, current_health);
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? ��駤�Ҿ�ѧ���Ե����Ѻ: {FFFF00}%s\n\n" \
        "{00FF00}? ��ѧ���Ե�Ѩ�غѹ: {FFFFFF}%.1f/100\n\n" \
        "{FFFFFF}��س�����Ҿ�ѧ���Ե���� (1-100):",
        playername, current_health
    );
    
    SetPVarInt(playerid, "AdminTargetID", targetid);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_SET_HEALTH, DIALOG_STYLE_INPUT,
        "?? ��駤�Ҿ�ѧ���Ե", dialog_content, "��駤��", "¡��ԡ");
    return 1;
}

// �ʴ� Dialog �Ѵ����Թ
stock ShowMoneyManagementDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? �����蹹������͹�Ź�!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[512];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    new current_money = GetPlayerMoney(targetid);
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? �Ѵ����Թ����Ѻ: {FFFF00}%s\n\n" \
        "{00FF00}? �Թ�Ѩ�غѹ: {FFFFFF}$%s\n\n" \
        "{FFFFFF}?? ����Թ\n" \
        "{FFFFFF}?? �ѡ�Թ",
        playername, FormatNumber(current_money)
    );
    
    SetPVarInt(playerid, "AdminTargetID", targetid);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_MONEY_MANAGE, DIALOG_STYLE_LIST,
        "?? �Ѵ����Թ", dialog_content, "���͡", "¡��ԡ");
    return 1;
}

// �ʴ� Dialog �м�����
stock ShowKickPlayerDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? �����蹹������͹�Ź�!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[512];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? �м�����: {FFFF00}%s\n\n" \
        "{FF6666}? ��á�зӹ��з����������͡�ҡ���������\n\n" \
        "{FFFFFF}��س�����˵ؼš����:",
        playername
    );
    
    SetPVarInt(playerid, "AdminTargetID", targetid);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_KICK_PLAYER, DIALOG_STYLE_INPUT,
        "?? �м�����", dialog_content, "��", "¡��ԡ");
    return 1;
}

// �ʴ� Dialog ẹ������
stock ShowBanPlayerDialog(playerid, targetid) {
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "? �����蹹������͹�Ź�!");
        return ShowPlayerManagementDialog(playerid);
    }
    
    new playername[MAX_PLAYER_NAME], dialog_content[512];
    GetPlayerName(targetid, playername, sizeof(playername));
    
    format(dialog_content, sizeof(dialog_content),
        "{FFFFFF}?? ẹ������: {FFFF00}%s\n\n" \
        "{FF3333}? ��á�зӹ�������������������������\n\n" \
        "{FFFFFF}��س�����˵ؼš��ẹ:",
        playername
    );
    
    SetPVarInt(playerid, "AdminTargetID", targetid);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_BAN_PLAYER, DIALOG_STYLE_INPUT,
        "?? ẹ������", dialog_content, "ẹ", "¡��ԡ");
    return 1;
}

// �ѧ��ѹ���¨Ѵ�ٻẺ����Ţ
stock FormatNumber(number) {
    new str[32];
    format(str, sizeof(str), "%d", number);
    return str;
}

// �ѧ��ѹ������ ID �����蹨ҡ listitem
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

// �ѧ��ѹ�м�����Ẻ��Ҫ��
forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid) {
    if(IsPlayerConnected(playerid)) {
        Kick(playerid);
    }
    return 1;
}

// --------------------------- Dialog Systems ---------------------------------
// �Ѵ��� Dialog ������㹷������ Ẻ switch statement Ẻ���

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        // ==================== LOGIN SYSTEM DIALOGS ====================
        case DIALOG_LOGIN: {
            if(!response) { // ������ "¡��ԡ"
                Kick(playerid);
                return 1;
            }
            // ������ "�������к�"
            if(strlen(inputtext) < 1) {
                SendClientMessage(playerid, -1, "{FF0000}��س�������ʼ�ҹ!");
                return ShowLoginDialog(playerid);
            }
            LoginPlayer(playerid, inputtext);
            return 1;
        }
        
        case DIALOG_REGISTER: {
            if(!response) { // ������ "¡��ԡ"
                Kick(playerid);
                return 1;
            }
            // ������ "��Ѥ���Ҫԡ"
            if(strlen(inputtext) < 1) {
                SendClientMessage(playerid, -1, "{FF0000}��س�������ʼ�ҹ!");
                return ShowRegisterDialog(playerid);
            }
            RegisterPlayer(playerid, inputtext);
            return 1;
        }
        
        // ==================== ADMIN SYSTEM DIALOGS ====================
        case DIALOG_ADMIN_MAIN: {
            if(!response) return 1; // �Դ dialog
            
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
                ShowAdminMainDialog(playerid); // ��Ѻ�˹����ѡ
                return 1;
            }
            
            switch(listitem) {
                case 0: { // Spawn Vehicle
                    SendClientMessage(playerid, 0x00FF00AA, "?? ������: /v [����ö] [��1] [��2]");
                    SendClientMessage(playerid, 0xFFFFFFAA, "������ҧ: /v 411 0 1");
                }
                case 1: { // Delete Vehicle
                    SendClientMessage(playerid, 0x00FF00AA, "?? ������: /dv ���� /deletevehicle");
                }
                case 2: { // Repair Vehicle
                    SendClientMessage(playerid, 0x00FF00AA, "?? ������: /fix ���� /repair");
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
                        format(info_msg, sizeof(info_msg), "?? ö���س�������: %s (ID: %d)", vehiclename, vehiclemodel);
                        SendClientMessage(playerid, 0x00DDFFAA, info_msg);
                    } else {
                        SendClientMessage(playerid, 0xFF0000AA, "? �س����������ö!");
                    }
                }
            }
            return 1;
        }
        
        case DIALOG_ADMIN_TELEPORT: {
            if(!response) {
                ShowAdminMainDialog(playerid); // ��Ѻ�˹����ѡ
                return 1;
            }
            
            switch(listitem) {
                case 0: { // Los Santos
                    SetPlayerPos(playerid, 1172.02, -1323.89, 15.00);
                    SendClientMessage(playerid, 0x00FF00AA, "?? ��ž���� Los Santos ����!");
                }
                case 1: { // San Fierro
                    SetPlayerPos(playerid, -2026.65, 156.66, 29.04);
                    SendClientMessage(playerid, 0x00FF00AA, "?? ��ž���� San Fierro ����!");
                }
                case 2: { // Las Venturas
                    SetPlayerPos(playerid, 2495.05, 1666.84, 11.04);
                    SendClientMessage(playerid, 0x00FF00AA, "?? ��ž���� Las Venturas ����!");
                }
                case 3: { // Custom Locations
                    SendClientMessage(playerid, 0xFFFF00AA, "?? Custom Locations - Coming Soon!");
                }
            }
            return 1;
        }
        
        case DIALOG_ADMIN_PLAYER_MANAGE: {
            if(!response) {
                ShowAdminMainDialog(playerid); // ��Ѻ�˹����ѡ
                return 1;
            }
            
            switch(listitem) {
                case 0: { // View Player Info
                    SetPVarString(playerid, "AdminAction", "info");
                    ShowPlayerListDialog(playerid, "�٢�����");
                }
                case 1: { // Set Health
                    SetPVarString(playerid, "AdminAction", "set_health");
                    ShowPlayerListDialog(playerid, "��駤�Ҿ�ѧ���Ե");
                }
                case 2: { // Give/Take Money
                    SetPVarString(playerid, "AdminAction", "money");
                    ShowPlayerListDialog(playerid, "�Ѵ����Թ");
                }
                case 3: { // Kick Player
                    SetPVarString(playerid, "AdminAction", "kick");
                    ShowPlayerListDialog(playerid, "�м�����");
                }
                case 4: { // Ban Player
                    SetPVarString(playerid, "AdminAction", "ban");
                    ShowPlayerListDialog(playerid, "ẹ������");
                }
            }
            return 1;
        }
        
        // �Ѵ�����ª��ͼ�����
        case DIALOG_ADMIN_PLAYER_LIST: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPlayerIDFromListitem(listitem);
            if(targetid == INVALID_PLAYER_ID) {
                SendClientMessage(playerid, 0xFF0000AA, "? ��辺�����蹷�����͡!");
                ShowPlayerListDialog(playerid, "���͡������");
                return 1;
            }
            
            // ��Ǩ�ͺ��� admin ������¡����ѧ����������
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
        
        // �Ѵ��õ�駤�Ҿ�ѧ���Ե
        case DIALOG_ADMIN_SET_HEALTH: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ����������͹�Ź�!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new health = strval(inputtext);
            if(health < 1 || health > 100) {
                SendClientMessage(playerid, 0xFF0000AA, "? ��Ҿ�ѧ���Ե��ͧ���������ҧ 1-100!");
                return ShowSetHealthDialog(playerid, targetid);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            SetPlayerHealth(targetid, float(health));
            
            new msg[128];
            format(msg, sizeof(msg), "? ��駤�Ҿ�ѧ���Ե�ͧ %s �� %d ����", playername, health);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            format(msg, sizeof(msg), "?? Admin %s ���駤�Ҿ�ѧ���Ե�ͧ�س�� %d", adminname, health);
            SendClientMessage(targetid, 0x00DDFFAA, msg);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
        
        // �Ѵ����Թ
        case DIALOG_ADMIN_MONEY_MANAGE: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ����������͹�Ź�!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new playername[MAX_PLAYER_NAME], dialog_content[256];
            GetPlayerName(targetid, playername, sizeof(playername));
            
            switch(listitem) {
                case 0: { // ����Թ
                    format(dialog_content, sizeof(dialog_content),
                        "{FFFFFF}?? ����Թ����Ѻ: {FFFF00}%s\n\n" \
                        "{00FF00}? �Թ�Ѩ�غѹ: {FFFFFF}$%s\n\n" \
                        "{FFFFFF}��س����ӹǹ�Թ�������:",
                        playername, FormatNumber(GetPlayerMoney(targetid))
                    );
                    
                    ShowPlayerDialog(playerid, DIALOG_ADMIN_MONEY_GIVE, DIALOG_STYLE_INPUT,
                        "?? ����Թ", dialog_content, "����Թ", "¡��ԡ");
                }
                case 1: { // �ѡ�Թ
                    format(dialog_content, sizeof(dialog_content),
                        "{FFFFFF}?? �ѡ�Թ����Ѻ: {FFFF00}%s\n\n" \
                        "{00FF00}? �Թ�Ѩ�غѹ: {FFFFFF}$%s\n\n" \
                        "{FFFFFF}��س����ӹǹ�Թ�����ѡ:",
                        playername, FormatNumber(GetPlayerMoney(targetid))
                    );
                    
                    ShowPlayerDialog(playerid, DIALOG_ADMIN_MONEY_TAKE, DIALOG_STYLE_INPUT,
                        "?? �ѡ�Թ", dialog_content, "�ѡ�Թ", "¡��ԡ");
                }
            }
            return 1;
        }
        
        // ����Թ
        case DIALOG_ADMIN_MONEY_GIVE: {
            if(!response) {
                new targetid = GetPVarInt(playerid, "AdminTargetID");
                ShowMoneyManagementDialog(playerid, targetid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ����������͹�Ź�!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new amount = strval(inputtext);
            if(amount < 1) {
                SendClientMessage(playerid, 0xFF0000AA, "? �ӹǹ�Թ��ͧ�ҡ���� 0!");
                return ShowMoneyManagementDialog(playerid, targetid);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            GivePlayerMoney(targetid, amount);
            
            new msg[128];
            format(msg, sizeof(msg), "? ����Թ $%s �� %s ����", FormatNumber(amount), playername);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            format(msg, sizeof(msg), "?? Admin %s ������Թ $%s ��س", adminname, FormatNumber(amount));
            SendClientMessage(targetid, 0x00DDFFAA, msg);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
        
        // �ѡ�Թ
        case DIALOG_ADMIN_MONEY_TAKE: {
            if(!response) {
                new targetid = GetPVarInt(playerid, "AdminTargetID");
                ShowMoneyManagementDialog(playerid, targetid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ����������͹�Ź�!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new amount = strval(inputtext);
            if(amount < 1) {
                SendClientMessage(playerid, 0xFF0000AA, "? �ӹǹ�Թ��ͧ�ҡ���� 0!");
                return ShowMoneyManagementDialog(playerid, targetid);
            }
            
            new current_money = GetPlayerMoney(targetid);
            if(amount > current_money) {
                SendClientMessage(playerid, 0xFF0000AA, "? ������������Թ��§��!");
                return ShowMoneyManagementDialog(playerid, targetid);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            GivePlayerMoney(targetid, -amount);
            
            new msg[128];
            format(msg, sizeof(msg), "? �ѡ�Թ $%s �ҡ %s ����", FormatNumber(amount), playername);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            format(msg, sizeof(msg), "?? Admin %s ���ѡ�Թ $%s �ҡ�س", adminname, FormatNumber(amount));
            SendClientMessage(targetid, 0xFFBB00AA, msg);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
        
        // �м�����
        case DIALOG_ADMIN_KICK_PLAYER: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ����������͹�Ź�!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new reason[128];
            if(strlen(inputtext) < 1) {
                format(reason, sizeof(reason), "����к��˵ؼ�");
            } else {
                format(reason, sizeof(reason), "%s", inputtext);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            new msg[256];
            format(msg, sizeof(msg), "?? %s �١���� Admin %s | �˵ؼ�: %s", playername, adminname, reason);
            SendClientMessageToAll(0xFF6666AA, msg);
            
            format(msg, sizeof(msg), "?? �س�١�Шҡ����������� Admin %s | �˵ؼ�: %s", adminname, reason);
            SendClientMessage(targetid, 0xFF6666AA, msg);
            
            format(msg, sizeof(msg), "? �� %s �͡�ҡ������������� | �˵ؼ�: %s", playername, reason);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            SetTimerEx("KickPlayerDelayed", 1000, false, "i", targetid);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
        
        // ẹ������
        case DIALOG_ADMIN_BAN_PLAYER: {
            if(!response) {
                ShowPlayerManagementDialog(playerid);
                return 1;
            }
            
            new targetid = GetPVarInt(playerid, "AdminTargetID");
            if(!IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, 0xFF0000AA, "? ����������͹�Ź�!");
                return ShowPlayerManagementDialog(playerid);
            }
            
            new reason[128];
            if(strlen(inputtext) < 1) {
                format(reason, sizeof(reason), "����к��˵ؼ�");
            } else {
                format(reason, sizeof(reason), "%s", inputtext);
            }
            
            new playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
            GetPlayerName(targetid, playername, sizeof(playername));
            GetPlayerName(playerid, adminname, sizeof(adminname));
            
            // �ѹ�֡�����š��ẹŧ��� bans.json (�����) ���� ban IP
            new playerip[16];
            GetPlayerIp(targetid, playerip, sizeof(playerip));
            
            new msg[256];
            format(msg, sizeof(msg), "?? %s �١ẹ�� Admin %s | �˵ؼ�: %s", playername, adminname, reason);
            SendClientMessageToAll(0xFF3333AA, msg);
            
            format(msg, sizeof(msg), "?? �س�١ẹ�ҡ����������� Admin %s | �˵ؼ�: %s", adminname, reason);
            SendClientMessage(targetid, 0xFF3333AA, msg);
            
            format(msg, sizeof(msg), "? ẹ %s (IP: %s) ���� | �˵ؼ�: %s", playername, playerip, reason);
            SendClientMessage(playerid, 0x00FF00AA, msg);
            
            // ẹ IP
            new ban_cmd[64];
            format(ban_cmd, sizeof(ban_cmd), "banip %s", playerip);
            SendRconCommand(ban_cmd);
            
            SetTimerEx("KickPlayerDelayed", 1500, false, "i", targetid);
            
            DeletePVar(playerid, "AdminTargetID");
            DeletePVar(playerid, "AdminAction");
            return 1;
        }
    }
    
    return 0; // ��辺 dialog ���ç�ѹ
}
