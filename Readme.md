# Simple Dockerfile for the SDL-Labs' Hyperion-4 OS360 Emulator
See https://github.com/SDL-Hercules-390/hyperion
## Building

`docker build -t mariocki/hyperion-docker:1.0 .`

## Running

`docker run -p 3270:3270 --rm -itd -v ~/tk4-docker:/tk4 mariocki/hyperion-docker:1.0`

## Logging in
Start c3270 :

`c3270 localhost:3270`

Once connected:

`logon HERC01` or `logon HERC02`

and the password is `CUL8TR`

## Shutting down

Exit out of TSO then enter

```
shutdown
logoff
```

`Ctrl-n` brings up the mnu in c3270
