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
`docker run --cap-add=NET_ADMIN -p 3270:3270 -p 8038:8038 -p 21000:21000 --rm -itd -v ~/tk4:/tk4 mariocki/hyperion-docker:1.0`

By default x3270 connects on port 3270, port 8038 is the Web console and 21000 is the FTP port (see below)
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

Reattaching to a session in TSO console: `logon <username> reconnect`

Starting FTP server,in the console run `/start ftpd,srvport=2100`

What DASD devices are usable: `SYS1.SYSGEN.CNTL(IOGEN)`

To mount a DASD manually

```
attach 250 3330 dasd/<<filename>
/v 250,online
/m 250,vol=(sl,<<Top Level DSN Name>>),use=private
```
or see http://www.jaymoseley.com/hercules/installMVS/addingDasdV7.htm

To run a jcl file in the tk4/jcl folder, in the console run 
`devinit 00c jcl/<<filename>> eof`

## Algol68C
Download from https://algol68c.bitbucket.io/370/Algol68C_Release_1.3039.html/
Then follow instructions on https://jmvdveer.home.xs4all.nl/en.post.algol-68-mvs.html#install and https://jmvdveer.home.xs4all.nl/en.post.algol-68-mvs-revisited.html
## Links
* https://sdl-hercules-390.github.io/html/
* https://kevindurant.be/2019/03/17/mom-part-1-setting-up-my-own-mainframe/
* https://bsp-gmbh.pocnet.net/turnkey/cookbook/index.html [tk3 archive of site]
* https://www.tutorialspoint.com/jcl/index.htm
* http://wotho.ethz.ch/tk4-/ [tk4- main site]
* http://featherriver.net/gettingMVS.html [includes how to create a new user]
* https://algol68c.bitbucket.io/370/Algol68C_Release_1.3039.html/ [Algol68C DASD and AWS tape image]
