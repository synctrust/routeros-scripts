#!rsc by RouterOS
# RouterOS script: accesslist-duplicates.wifiwave2
# Copyright (c) 2018-2024 Christian Hesse <mail@eworm.de>
# https://git.eworm.de/cgit/routeros-scripts/about/COPYING.md
#
# requires RouterOS, version=7.12
#
# print duplicate antries in wireless access list
# https://git.eworm.de/cgit/routeros-scripts/about/doc/accesslist-duplicates.md
#
# !! Do not edit this file, it is generated from template!

:local 0 "accesslist-duplicates.wifiwave2";
:global GlobalFunctionsReady;
:while ($GlobalFunctionsReady != true) do={ :delay 500ms; }

:local Seen ({});

:foreach AccList in=[ /interface/wifiwave2/access-list/find where mac-address!="00:00:00:00:00:00" ] do={
  :local Mac [ /interface/wifiwave2/access-list/get $AccList mac-address ];
  :if ($Seen->$Mac = 1) do={
    /interface/wifiwave2/access-list/print where mac-address=$Mac;
    :local Remove [ :tonum [ /terminal/ask prompt="\nNumeric id to remove, any key to skip!" ] ];

    :if ([ :typeof $Remove ] = "num") do={
      :put ("Removing numeric id " . $Remove . "...\n");
      /interface/wifiwave2/access-list/remove $Remove;
    }
  }
  :set ($Seen->$Mac) 1;
}
