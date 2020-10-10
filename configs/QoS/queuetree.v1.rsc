/queue type
add kind=pcq name=PCQ_Upload pcq-classifier=src-address pcq-rate=35M
add kind=pcq name=PCQ_Download pcq-classifier=dst-address pcq-rate=200M
set 7 pcq-rate=35M ; Upload Speed To ISP
set 8 pcq-rate=200M ; Download Speed To ISP

/queue tree
add name=Download parent=Bridge-LAN queue=PCQ_Download
add name=Upload parent=ether1 queue=PCQ_Upload
add limit-at=10M max-limit=20M name="Prioridad 1 Down" packet-mark=P1 parent=Download priority=1 queue=PCQ_Download
add limit-at=10M max-limit=160M name="Prioridad 2 Down" packet-mark=P2 parent=Download priority=2 queue=PCQ_Download
add limit-at=15M max-limit=160M name="Prioridad 3 Down" packet-mark=P3 parent=Download priority=3 queue=PCQ_Download
add limit-at=20M max-limit=50M name="Prioridad 4 Down" packet-mark=P4 parent=Download priority=4 queue=PCQ_Download
add limit-at=20M max-limit=160M name="Prioridad 5 Down" packet-mark=P5 parent=Download priority=5 queue=PCQ_Download
add limit-at=70M max-limit=150M name="Prioridad 6 Down" packet-mark=P6 parent=Download priority=6 queue=PCQ_Download
add limit-at=25M max-limit=70M name="Prioridad 7 Down" packet-mark=P7 parent=Download priority=7 queue=PCQ_Download
add limit-at=3M max-limit=10M name="Prioridad 1 Up" packet-mark=P1 parent=Upload priority=1 queue=PCQ_Upload
add limit-at=5M max-limit=10M name="Prioridad 2 Up" packet-mark=P2 parent=Upload priority=2 queue=PCQ_Upload
add limit-at=10M max-limit=30M name="Prioridad 3 Up" packet-mark=P3 parent=Upload priority=3 queue=PCQ_Upload
add limit-at=10M max-limit=18M name="Prioridad 4 Up" packet-mark=P4 parent=Upload priority=4 queue=PCQ_Upload
add limit-at=5M max-limit=25M name="Prioridad 5 Up" packet-mark=P5 parent=Upload priority=5 queue=PCQ_Upload
add limit-at=8M max-limit=25M name="Prioridad 6 Up" packet-mark=P6 parent=Upload priority=6 queue=PCQ_Upload
add limit-at=10M max-limit=20M name="Prioridad 7 Up" packet-mark=P7 parent=Upload priority=7 queue=PCQ_Upload


/ip firewall mangle
add action=mark-connection chain=prerouting comment="Priority 1 -- ICMP/DNS/VOIP" new-connection-mark=priority1_conn passthrough=yes protocol=icmp
add action=mark-connection chain=prerouting new-connection-mark=priority1_conn passthrough=yes port=53 protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=priority1_conn passthrough=yes port=5060,5061,10000-20000 protocol=udp
add action=mark-connection chain=prerouting comment="Priority 2 HTTP/HTTPS --- SMALL + GAMING" connection-bytes=1-512000 new-connection-mark=priority2_conn passthrough=yes port=80,443,8080 \
    protocol=tcp
add action=mark-connection chain=prerouting new-connection-mark=priority2_conn passthrough=yes port=88,3074,500,3544,4500,3478,3479 protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=priority2_conn passthrough=yes port=3074,53,465,3478,3479,3480,5223 protocol=tcp
add action=mark-connection chain=prerouting comment="Priority 3 -- HTTP/HTTPS MEDIUM" connection-bytes=512000-3000000 new-connection-mark=priority3_conn passthrough=yes port=80,443,8080 \
    protocol=tcp
add action=mark-connection chain=prerouting comment="Priority 4 -- MESSENGERS/MAIL" new-connection-mark=priority4_conn passthrough=yes port=\
    25,110,143,465,480,5223,993,995,4244,5222,5223,5228,5242,50318,59234 protocol=tcp
add action=mark-connection chain=prerouting new-connection-mark=priority4_conn passthrough=yes port=16393-16472 protocol=udp
add action=mark-connection chain=prerouting comment="Priority 5 -- HTTP/HTTPS BIG <20M" connection-bytes=40000000-0 new-connection-mark=priority5_conn passthrough=yes port=80,443,8080 \
    protocol=tcp
add action=mark-connection chain=prerouting comment="Priority 6 -- STREAMING / YOUTUBE / NETFLIX / AMAZON / CRACKLE" new-connection-mark=priority6_conn passthrough=yes port=443 protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=priority6_conn passthrough=yes src-address-list=youtube
add action=mark-connection chain=prerouting new-connection-mark=priority6_conn passthrough=yes src-address-list=netflix
add action=mark-connection chain=prerouting comment="Priority 7 - DOWNLOADS <100" connection-bytes=100000000-0 new-connection-mark=priority7_conn passthrough=yes port=80,443,21 protocol=tcp
add action=mark-packet chain=prerouting comment="Prioridad 1" connection-mark=priority1_conn new-packet-mark=P1 passthrough=no
add action=mark-packet chain=prerouting comment="Prioridad 2" connection-mark=priority2_conn new-packet-mark=P2 passthrough=no
add action=mark-packet chain=prerouting comment="Prioridad 3" connection-mark=priority3_conn new-packet-mark=P3 passthrough=no
add action=mark-packet chain=prerouting comment="Prioridad 4" connection-mark=priority4_conn new-packet-mark=P4 passthrough=no
add action=mark-packet chain=prerouting comment="Prioridad 5" connection-mark=priority5_conn new-packet-mark=P5 passthrough=no
add action=mark-packet chain=prerouting comment="Prioridad 6" connection-mark=priority6_conn new-packet-mark=P6 passthrough=no
add action=mark-packet chain=prerouting comment="Prioridad 7" connection-mark=priority7_conn new-packet-mark=P7 passthrough=no
