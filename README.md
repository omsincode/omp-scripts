# ??? StarTown - Open.MP Gamemode

[![Open.MP](https://img.shields.io/badge/Open.MP-Compatible-green)](https://www.open.mp/)
[![PAWN](https://img.shields.io/badge/Language-PAWN-blue)](https://github.com/pawn-lang/compiler)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## ?? Project Overview

**StarTown** is a San Andreas Multiplayer gamemode developed with Open.MP featuring comprehensive player management, database systems, and complete admin commands.

### ? Key Features

- ?? **User System** - Login/Register with MySQL database
- ?? **Auto Save** - Player data saved every 5 minutes
- ?? **Admin System** - Server management commands
- ?? **Vehicle System** - Spawn, delete and repair vehicles
- ?? **Level System** - Experience and gameplay progression
- ??? **Data Protection** - Backup and recovery systems

## ?? Installation

### System Requirements
- Windows 10/11 or Linux
- MySQL Server 5.7+
- Open.MP Server

### Installation Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/omsincode/omp-script.git
   cd omp-script
   ```

2. **Setup Database**
   - Create MySQL database named `startown`
   - Import `database/startown.sql` file
   ```sql
   CREATE DATABASE startown;
   USE startown;
   SOURCE database/startown.sql;
   ```

3. **Configure Settings**
   - Open `systems/database.pwn` file
   - Edit database connection settings:
   ```pawn
   #define MYSQL_HOST      "localhost"
   #define MYSQL_USER      "your_username"
   #define MYSQL_PASSWORD  "your_password"
   #define MYSQL_DATABASE  "startown"
   ```

4. **Compile**
   - Use PAWN Compiler or qawno
   - Compile `gamemodes/main.pwn` file

5. **Run Server**
   ```bash
   ./omp-server
   ```

## ?? Project Structure

```
??? gamemodes/
?   ??? main.pwn              # Main gamemode file
?   ??? commands/             # Command files
?   ?   ??? admin_commands.pwn
?   ??? systems/              # System files
?       ??? database.pwn      # Database connection
?       ??? login_systems.pwn # User authentication
?       ??? save_systems.pwn  # Data saving system
?       ??? loads_systems.pwn # Data loading system
?       ??? dialog_systems.pwn# Dialog system
?       ??? player_data.pwn   # Player data management
??? database/
?   ??? startown.sql          # Database schema
??? components/               # Open.MP Components
??? plugins/                  # Plugins
??? scriptfiles/             # Additional files
```

## ?? In-Game Commands

### Admin Commands

| Short Command | Full Command | Description |
|---------------|--------------|-------------|
| `/v [id]` | `/vehicle [id] [color1] [color2]` | Spawn vehicle |
| `/dv` | `/deletevehicle` | Delete current vehicle |
| `/repair` | `/fix` | Repair current vehicle |

### Player Commands

- `/login [password]` - Login to account
- `/register [password]` - Register new account

## ??? Development

### Code Structure

This project uses Modular architecture:
- Each system is separated into specific files
- Include Guards prevent duplicate inclusions
- Thai comments for better understanding

### Code Style

```pawn
// Use Same-line braces
if (condition) {
    // code here
}

// 4 spaces indentation
function() {
    if (condition) {
        doSomething();
    }
}

// Thai comments for clarity
stock ConnectToDatabase() { // Connect to database
    // implementation
}
```

### Adding New Features

1. Create file in `systems/` or `commands/` folder
2. Add Include Guard
3. Add `#include` in `main.pwn` file
4. Test compilation

## ?? Database

### players Table

| Column | Type | Description |
|--------|------|-------------|
| player_id | INT | Player ID (Primary Key) |
| player_name | VARCHAR(24) | Player name |
| player_password | VARCHAR(255) | Password |
| player_admin | INT | Admin level |
| player_level | INT | Player level |
| player_xp | INT | Experience points |
| player_money | INT | Money |
| player_health | INT | Health |
| player_armour | INT | Armour |
| player_skin | INT | Player skin |
| player_posx | FLOAT | X position |
| player_posy | FLOAT | Y position |
| player_posz | FLOAT | Z position |
| player_angle | FLOAT | Facing angle |
| player_gang | INT | Gang ID |
| player_last_login | TIMESTAMP | Last login time |

## ?? Troubleshooting

### Common Issues

1. **Cannot connect to database**
   - Check settings in `database.pwn`
   - Verify MySQL Server is running

2. **Warning 217: loose indentation**
   - Use 4 spaces for indentation
   - Don't mix tabs and spaces

3. **Error 021: symbol already defined**
   - Check Include Guards
   - Don't include same file multiple times

## ?? Changelog

### v1.0.0 (2025-09-15)
- ? Basic user authentication system
- ? Auto save data system
- ? Admin commands for vehicles
- ? Modular code structure
- ? Separate dialog system

## ?? Contributing

To contribute to this project:

1. Fork the project
2. Create a Feature Branch
3. Commit your changes
4. Create a Pull Request

## ?? License

This project is licensed under [MIT License](LICENSE)

## ?? Contact

- **Developer:** omsincode
- **GitHub:** [omsincode](https://github.com/omsincode)
- **Discord:** [Join Discord Server](https://discord.gg/your-discord)

---

?? **Thank you for using StarTown Gamemode!** 

If you like this project, don't forget to give it a ? Star!