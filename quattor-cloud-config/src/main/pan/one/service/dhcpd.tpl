# ${BUILD_INFO}
#
# Created as part of the StratusLab project (http://stratuslab.eu)
#
# Copyright (c) 2010-2011, Centre National de la Recherche Scientifique
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unique template one/service/dhcpd;

include { 'components/filecopy/config' };

variable ONE_DHCP_DOMAIN ?= 'localhost';
variable ONE_DHCP_NAMESERVER ?= list('127.0.0.1');

variable ONE_DHCPD_PUBLIC_COMMON ?= nlist('subnet','192.168.0.0',
					 'router','127.0.0.1',
					 'netmask', '255.255.255.0');

variable ONE_DHCPD_PRIVATE_COMMON ?= nlist('subnet','172.17.16.0',
					  'router','127.0.0.1',
					  'netmask', '255.255.255.0');

#
# ONE_DHCP_PUBLIC and ONE_DHCP_PRIVATE must be like nlist('machine-name',nlist('mac-address','value-of-mac-address','fixed-address','value-of-fixed-address'))
#

variable ONE_DHCP_PUBLIC ?= nlist();
variable ONE_DHCP_PRIVATE ?= nlist();

variable DHCPD_CONF = <<EOF;
# LAL main DHCP server configuration

authoritative;
allow bootp;
ddns-update-style none;
EOF

variable DHCPD_CONF = DHCPD_CONF + 'option domain-name "'+ONE_DHCP_DOMAIN+"\";\n";

variable ONE_DHCP_NAMESERVER_STRING = {
	contents = '';
	foreach (k;v;ONE_DHCP_NAMESERVER) {
		if ( contents == '') {
			contents = v;
		} else {
			contents = contents + ',' + v;
		}
	};
	contents;
};

variable DHCPD_CONF = DHCPD_CONF + 'option domain-name-servers '+ONE_DHCP_NAMESERVER_STRING+" ;\n";

variable DHCPD_CONF = DHCPD_CONF + <<EOF;
#----------------------------------------------------------
group {
EOF

variable DHCPD_CONF = DHCPD_CONF + '        option routers '+ONE_DHCPD_PUBLIC_COMMON['router']+";\n";
variable DHCPD_CONF = DHCPD_CONF + '        option subnet-mask '+ONE_DHCPD_PUBLIC_COMMON['netmask']+";\n";

variable PUBLIC_CONF_STRING = {
	contents = '';
	foreach (k;v;ONE_DHCP_PUBLIC) {
		contents = contents + 'host '+k+" {\n";
		contents = contents + '    hardware ethernet '+v['mac-address']+";\n";
		contents = contents + '    fixed-address '+v['fixed-address']+";\n";
		contents = contents + "}\n";
	};
	contents;
};

variable DHCPD_CONF = DHCPD_CONF + PUBLIC_CONF_STRING;
variable DHCPD_CONF = DHCPD_CONF + <<EOF;
}
EOF

variable DHCPD_CONF = DHCPD_CONF + <<EOF;
#----------------------------------------------------------
group {
EOF

variable DHCPD_CONF = DHCPD_CONF + '        option routers '+ONE_DHCPD_PRIVATE_COMMON['router']+";\n";
variable DHCPD_CONF = DHCPD_CONF + '        option subnet-mask '+ONE_DHCPD_PRIVATE_COMMON['netmask']+";\n";

variable PRIVATE_CONF_STRING = {
	contents = '';
	foreach (k;v;ONE_DHCP_PRIVATE) {
		contents = contents + 'host '+k+" {\n";
		contents = contents + '    hardware ethernet '+v['mac-address']+";\n";
		contents = contents + '    fixed-address '+v['fixed-address']+";\n";
		contents = contents + "}\n";
	};
	contents;
};

#variable DHCPD_CONF = DHCPD_CONF + PRIVATE_CONF_STRING;
variable DHCPD_CONF = DHCPD_CONF + <<EOF;
}
EOF

variable DHCPD_CONF = DHCPD_CONF + <<EOF;
#----------------------------------------------------------
shared-network StratusLab-LAN {
EOF

variable SHARED_NETWORK_STRING = {
	contents = '';
	contents = contents + 'subnet '+ONE_DHCPD_PRIVATE_COMMON['subnet']+' netmask '+ONE_DHCPD_PRIVATE_COMMON['netmask']+" {\n";
	contents = contents + '        option routers '+ONE_DHCPD_PRIVATE_COMMON['router']+";\n";
	contents = contents + "}\n";
	contents = contents + 'subnet '+ONE_DHCPD_PUBLIC_COMMON['subnet']+' netmask '+ONE_DHCPD_PUBLIC_COMMON['netmask']+" {\n";
	contents = contents + '        option vendor-encapsulated-options 01:04:00:00:00:00:ff'+";\n";
	contents = contents + '        option routers '+ONE_DHCPD_PUBLIC_COMMON['router']+";\n";
	contents = contents + '        next-server 134.158.75.2'+";\n";
	contents = contents + '        filename "/one/pxelinux.0"'+";\n";
	contents = contents + "}\n";
	contents;
};

variable DHCPD_CONF = DHCPD_CONF + SHARED_NETWORK_STRING;
variable DHCPD_CONF = DHCPD_CONF + <<EOF;
}
EOF

"/software/components/filecopy/services" = npush(
        escape("/etc/dhcp/dhcpd.conf"),
        nlist("config",DHCPD_CONF,
              "owner","root",
              "group","root",
              "perms","0644",
              "restart","/usr/bin/killall -HUP dhcpd")
    );


include { 'components/chkconfig/config' };
"/software/components/chkconfig/service/dhcpd/on" = "";
"/software/components/chkconfig/service/dhcpd/startstop" = true;

