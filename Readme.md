# Simple Dockerfile for the SDL-Labs' Hyperion-4 OS360 Emulator
See https://github.com/SDL-Hercules-390/hyperion
## Building

`docker compose build`

## Running

`docker compose up -d`

## Logging in
Start c3270 :

`c3270 localhost:3270`

Once connected:

`logon HERC01` or `logon HERC02`

and the password is `CUL8TR`

## Shutting down

Exit out of TSO into the MVS console then enter

```
shutdown
logoff
```

`Ctrl-n` brings up the menu in c3270
