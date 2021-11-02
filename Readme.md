# Simple Dockerfile for SDL-Labs' Hercules 4.x (Hyperion) System/370 and ESA/390 Emulator
See https://github.com/SDL-Hercules-390/hyperion

## Installing the runtime
Download the latest verion of tk4- from http://wotho.ethz.ch/tk4-/ and extract it into ~/tk4

## If using docker compose
### Building and running
`docker compose up --build -d`

## If using docker
### Building
`docker build -t mariocki/hyperion-docker:1.0 .`
### Running
`docker run -p 3270:3270 -p 8038:8038 --rm -itd -v ~/tk4:/tk4 mariocki/hyperion-docker:1.0`

## Logging in
Start c3270 :

`c3270 -model 3279-5 -oversize auto localhost:3270`

Once connected:

`logon HERC01` or `logon HERC02`

and the password is `CUL8TR`

## Web Console
open a browser a nd go to
`http://localhost:8038`

## Shutting down

Exit out of TSO into the MVS console then enter

```
shutdown
logoff
```

## Built in Users
* HERC01 / CUL8TR - fully authorized user with full access to the RAKF users and profiles tables.
* HERC02 / CUL8TR - fully authorized user without access to the RAKF users and profiles tables.
* HERC03 / PASS4U - regular user.
* HERC04 / PASS4U - regular user.
* IBMUSER / IBMPASS - fully authorized user without access to the RAKF users and profiles tables. This account is meant to be used for recovery purposes only

## TIPS
`Ctrl-n` brings up the menu in c3270

Reattaching to a session:
`logon <username> reconnect`

## Links
* https://sdl-hercules-390.github.io/html/
* https://kevindurant.be/2019/03/17/mom-part-1-setting-up-my-own-mainframe/
* https://bsp-gmbh.pocnet.net/turnkey/cookbook/index.html [tk3 archive of site]
* https://www.tutorialspoint.com/jcl/index.htm
* http://wotho.ethz.ch/tk4-/ [tk4- main site]
* http://featherriver.net/gettingMVS.html [includes how to create a new user]

