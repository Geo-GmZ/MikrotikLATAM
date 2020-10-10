/system script
add dont-require-permissions=yes name=DHCPtoDNS owner=sysadmin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# Domain to be added to your DHCP-clients hostname\r\
    \n:local topdomain;\r\
    \n:set topdomain \"lan\";\r\
    \n\r\
    \n# Use ttl to distinguish dynamic added DNS records\r\
    \n:local ttl;\r\
    \n:set ttl \"00:59:59\";\r\
    \n\r\
    \n# Set variables to use\r\
    \n:local hostname;\r\
    \n:local hostip;\r\
    \n:local free;\r\
    \n\r\
    \n# Remove all dynamic records\r\
    \n/ip dns static;\r\
    \n:foreach a in=[find] do={\r\
    \n  :if ([get \$a ttl] = \$ttl) do={\r\
    \n    :put (\"Removing: \" . [get \$a name] . \" : \" . [get \$a address]);\r\
    \n    remove \$a;\r\
    \n  }\r\
    \n}\r\
    \n\r\
    \n/ip dhcp-server lease ;\r\
    \n:foreach i in=[find] do={\r\
    \n  /ip dhcp-server lease ;\r\
    \n  :if ([:len [get \$i host-name]] > 0) do={\r\
    \n    :set free \"true\";\r\
    \n    :set hostname ([get \$i host-name] . \".\" . \$topdomain);\r\
    \n    :set hostip [get \$i address];\r\
    \n    /ip dns static ;\r\
    \n# Check if entry already exist\r\
    \n    :foreach di in [find] do={\r\
    \n      :if ([get \$di name] = \$hostname) do={\r\
    \n        :set free \"false\";\r\
    \n        :put (\"Not adding already existing entry: \" . \$hostname);\r\
    \n      }\r\
    \n    }\r\
    \n    :if (\$free = true) do={\r\
    \n      :put (\"Adding: \" . \$hostname . \" : \" . \$hostip ) ;\r\
    \n      /ip dns static add name=\$hostname address=\$hostip ttl=\$ttl;\r\
    \n    }\r\
    \n  }\r\
    \n}"
