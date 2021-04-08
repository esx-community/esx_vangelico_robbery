# esx_vangelico_robbery
ESX Vangelico Robbery V 2.0.0

Original Author: SerseDioRe. Edited by Vyast#0001.

Various server-sided security checks have been added to this resource, as there were multiple exploitable server events before that modders could easily take advantage of to recieve & sell jewels for money without actually robbing the jewelry store. 

When a player attempts to:
- Recieve Jewels: The server will first check if a jewelry robbery at any location is currently active, then it will proceed to check if the player that triggered this event is the same player that started the robbery and is actively robbing that location.
- Sell Jewels: The server will first check if the player who triggered this event has the minimum required amount of jewels that you need to sell, then it will proceed to check the players current distance from the jewelry sales location designated in the config.

The client side of this resource has also been optimized and runs at 0.01ms when not near a robbery or sales location, 0.04ms when near a location, and ranges anywhere from 0.01ms to 0.10ms while actively robbing a location or selling jewels.

[REQUIREMENTS]

* FiveM-ipl   => https://github.com/ESX-PUBLIC/fivem-ipl
* esx_policejob => https://github.com/ESX-Org/esx_policejob

[INSTALLATION]

1) CD in your resources/[esx] folder
2) Clone the repository
3) Import esx_vangelico_robbery.sql in your database
4) Add this in your server.cfg :

```
start esx_vangelico_robbery
```

[ORIGINAL SCRIPT]

* esx_holdup => https://github.com/ESX-Org/esx_holdup

[OLD VIDEO]

* https://www.youtube.com/watch?v=MivP5hU5m8A

[NEW VIDEO]

* https://streamable.com/y11r7
