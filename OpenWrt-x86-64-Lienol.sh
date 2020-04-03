
#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

# 添加第三方软件包
git clone https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone https://github.com/vernesong/OpenClash package/openclash
git clone https://github.com/kang-mk/luci-app-serverchan package/luci-app-serverchan
git clone https://github.com/kang-mk/luci-app-smartinfo package/luci-app-smartinfo

# 自定义定制选项
sed -i 's#192.168.1.1#10.0.0.1#g' package/base-files/files/bin/config_generate #定制默认IP
sed -i 's#max-width:200px#max-width:1000px#g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm #修改首页样式
sed -i 's#max-width:200px#max-width:1000px#g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index_x86.htm #修改X86首页样式
sed -i 's#option commit_interval 24h#option commit_interval 10m#g' feeds/packages/net/nlbwmon/files/nlbwmon.config #修改流量统计写入为10分钟
sed -i 's#option database_directory /var/lib/nlbwmon#option database_directory /etc/config/nlbwmon_data#g' feeds/packages/net/nlbwmon/files/nlbwmon.config #修改流量统计数据存放默认位置
sed -i 's#o.default = "admin"#o.default = ""#g' lienol/luci-app-passwall/luasrc/model/cbi/passwall/balancing.lua #去除haproxy默认密码(最新版已无密码)
sed -i 's#page = entry({"admin", "network"#page = entry({"admin", "control"#g' package/OpenAppFilter/luci-app-oaf/luasrc/controller/appfilter.lua #更换应用控制菜单

# 创建自定义配置文件 - OpenWrt-x86-64

rm -f ./.config*
touch ./.config

#
# ========================固件定制部分========================
# 

# 
# 如果不对本区块做出任何编辑, 则生成默认配置固件. 
# 

# 以下为定制化固件选项和说明:
#

#
# 有些插件/选项是默认开启的, 如果想要关闭, 请参照以下示例进行编写:
# 
#          =========================================
#         |  # 取消编译VMware镜像:                   |
#         |  cat >> .config <<EOF                   |
#         |  # CONFIG_VMDK_IMAGES is not set        |
#         |  EOF                                    |
#          =========================================
#

# 
# 以下是一些提前准备好的一些插件选项.
# 直接取消注释相应代码块即可应用. 不要取消注释代码块上的汉字说明.
# 如果不需要代码块里的某一项配置, 只需要删除相应行.
#
# 如果需要其他插件, 请按照示例自行添加.
# 注意, 只需添加依赖链顶端的包. 如果你需要插件 A, 同时 A 依赖 B, 即只需要添加 A.
# 
# 无论你想要对固件进行怎样的定制, 都需要且只需要修改 EOF 回环内的内容.
# 

# 编译x64固件:
cat >> .config <<EOF
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_Generic=y
EOF

# 设置固件大小:
cat >> .config <<EOF
CONFIG_TARGET_KERNEL_PARTSIZE=16
CONFIG_TARGET_ROOTFS_PARTSIZE=160
EOF

# 固件压缩:
cat >> .config <<EOF
CONFIG_TARGET_IMAGES_GZIP=y
EOF

# 编译UEFI固件(暂无引导支持):
# cat >> .config <<EOF
# CONFIG_EFI_IMAGES=y
# EOF

# IPv6支持:
cat >> .config <<EOF
CONFIG_PACKAGE_ipv6helper=y
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
EOF

# 多文件系统支持:
# cat >> .config <<EOF
# CONFIG_PACKAGE_kmod-fs-nfs=y
# CONFIG_PACKAGE_kmod-fs-nfs-common=y
# CONFIG_PACKAGE_kmod-fs-nfs-v3=y
# CONFIG_PACKAGE_kmod-fs-nfs-v4=y
# CONFIG_PACKAGE_kmod-fs-ntfs=y
# CONFIG_PACKAGE_kmod-fs-squashfs=y
# EOF

# USB3.0支持:
# cat >> .config <<EOF
# CONFIG_PACKAGE_kmod-usb-ohci=y
# CONFIG_PACKAGE_kmod-usb-ohci-pci=y
# CONFIG_PACKAGE_kmod-usb2=y
# CONFIG_PACKAGE_kmod-usb2-pci=y
# CONFIG_PACKAGE_kmod-usb3=y
# EOF

# 第三方插件选择:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-oaf=y #应用过滤
# CONFIG_PACKAGE_luci-app-openclash=y #OpenClash客户端
CONFIG_PACKAGE_luci-app-serverchan=y #微信推送
# CONFIG_PACKAGE_luci-app-smartinfo=y #磁盘健康监控
EOF

# Passwall插件:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ipt2socks=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_socks=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_socks=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_v2ray-plugin=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_simple-obfs=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Brook=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_kcptun=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_haproxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_dns2socks=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_pdnsd=y
CONFIG_PACKAGE_kcptun-client=y
CONFIG_PACKAGE_chinadns-ng=y
CONFIG_PACKAGE_haproxy=y
CONFIG_PACKAGE_v2ray=y
CONFIG_PACKAGE_v2ray-plugin=y
CONFIG_PACKAGE_simple-obfs=y
CONFIG_PACKAGE_trojan=y
CONFIG_PACKAGE_brook=y
CONFIG_PACKAGE_ipt2socks=y
CONFIG_PACKAGE_shadowsocks-libev-config=y
CONFIG_PACKAGE_shadowsocks-libev-ss-local=y
CONFIG_PACKAGE_shadowsocks-libev-ss-redir=y
CONFIG_PACKAGE_shadowsocksr-libev-alt=y
CONFIG_PACKAGE_shadowsocksr-libev-ssr-local=y
EOF

# 常用LuCI插件(禁用):
cat >> .config <<EOF
# CONFIG_PACKAGE_luci-app-smartdns is not set #smartdnsDNS服务
# CONFIG_PACKAGE_luci-app-adguardhome is not set #ADguardHome去广告服务
# CONFIG_PACKAGE_luci-app-unblockmusic is not set #解锁网易云灰色歌曲
# CONFIG_PACKAGE_luci-app-unblockneteasemusic-go is not set #解锁网易云灰色歌曲
# CONFIG_PACKAGE_luci-app-unblockneteasemusic-mini is not set #解锁网易云灰色歌曲
# CONFIG_PACKAGE_luci-app-xlnetacc is not set #迅雷快鸟
# CONFIG_PACKAGE_luci-app-usb-printer is not set #USB打印机
# CONFIG_PACKAGE_luci-app-mwan3helper is not set #多拨负载均衡
# CONFIG_PACKAGE_luci-app-mwan3 is not set #多线多拨
# CONFIG_PACKAGE_luci-app-hd-idle is not set #磁盘休眠
# CONFIG_PACKAGE_luci-app-wrtbwmon is not set #实时流量监测
#
# passwall相关(禁用):
#
#
# VPN相关插件(禁用):
#
# CONFIG_PACKAGE_luci-app-ipsec-vpnserver-manyusers is not set #ipsec VPN服务
# CONFIG_PACKAGE_luci-app-zerotier is not set #Zerotier内网穿透
# CONFIG_PACKAGE_luci-app-pppoe-relay is not set #PPPoE穿透
# CONFIG_PACKAGE_luci-app-pppoe-server is not set #PPPoE服务器
# CONFIG_PACKAGE_luci-app-pptp-vpnserver-manyusers is not set #PPTP VPN 服务器
# CONFIG_PACKAGE_luci-app-trojan-server is not set #Trojan服务器
# CONFIG_PACKAGE_luci-app-v2ray-server is not set #V2ray服务器
# CONFIG_PACKAGE_luci-app-brook-server is not set #brook服务端
# CONFIG_PACKAGE_luci-app-ssr-libev-server is not set #ssr-libev服务端
# CONFIG_PACKAGE_luci-app-ssr-python-pro-server is not set #ssr-python服务端
# CONFIG_PACKAGE_luci-app-kcptun is not set #Kcptun客户端
#
# 文件共享相关(禁用):
#
# CONFIG_PACKAGE_luci-app-aria2 is not set #Aria2离线下载
# CONFIG_PACKAGE_luci-app-minidlna is not set #miniDLNA服务
# CONFIG_PACKAGE_luci-app-kodexplorer is not set #可到私有云
# CONFIG_PACKAGE_luci-app-filebrowser is not set #File Browser私有云
# CONFIG_PACKAGE_luci-app-fileassistant is not set #文件助手
# CONFIG_PACKAGE_luci-app-vsftpd is not set #FTP 服务器
# CONFIG_PACKAGE_luci-app-samba is not set #网络共享
# CONFIG_PACKAGE_autosamba is not set #网络共享
# CONFIG_PACKAGE_samba36-server is not set #网络共享
EOF

# 常用LuCI插件(启用):
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-adbyby-plus=y #adbyby去广告
CONFIG_PACKAGE_luci-app-webadmin=y #Web管理页面设置
CONFIG_PACKAGE_luci-app-filetransfer=y #系统-文件传输
CONFIG_PACKAGE_luci-app-autoreboot=y #定时重启
CONFIG_PACKAGE_luci-app-frpc=y #Frp内网穿透
CONFIG_PACKAGE_luci-app-upnp=y #通用即插即用UPnP(端口自动转发)
CONFIG_PACKAGE_luci-app-softethervpn=y #SoftEtherVPN服务器
CONFIG_DEFAULT_luci-app-vlmcsd=y #KMS激活服务器
CONFIG_PACKAGE_luci-app-sqm=y #SQM智能队列管理
CONFIG_PACKAGE_luci-app-ddns=y #DDNS服务
CONFIG_PACKAGE_luci-app-wol=y #网络唤醒
CONFIG_PACKAGE_luci-app-control-mia=y #时间控制
CONFIG_PACKAGE_luci-app-control-timewol=y #定时唤醒
CONFIG_PACKAGE_luci-app-control-webrestriction=y #访问限制
CONFIG_PACKAGE_luci-app-control-weburl=y #网址过滤
CONFIG_PACKAGE_luci-app-flowoffload=y #Turbo ACC 网络加速
CONFIG_PACKAGE_luci-app-nlbwmon=y #宽带流量监控
EOF

# LuCI主题:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-theme-argon-dark-mod=y
CONFIG_PACKAGE_luci-theme-argon-light-mod=y
CONFIG_PACKAGE_luci-theme-bootstrap=y
# CONFIG_PACKAGE_luci-theme-bootstrap-mod is not set
# CONFIG_PACKAGE_luci-theme-darkmatter is not set
# CONFIG_PACKAGE_luci-theme-freifunk-generic is not set
# CONFIG_PACKAGE_luci-theme-material is not set
# CONFIG_PACKAGE_luci-theme-openwrt is not set
EOF

# 常用软件包:
cat >> .config <<EOF
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_nano=y
# CONFIG_PACKAGE_screen=y
# CONFIG_PACKAGE_tree=y
# CONFIG_PACKAGE_vim-fuller=y
CONFIG_PACKAGE_wget=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_node=y
EOF

# 存储和网络驱动:
cat >> .config <<EOF
# 存储驱动
CONFIG_PACKAGE_kmod-ata-core=y
CONFIG_PACKAGE_kmod-ata-ahci=y
CONFIG_PACKAGE_kmod-ata-artop=y
CONFIG_PACKAGE_kmod-ata-marvell-sata=y
CONFIG_PACKAGE_kmod-ata-nvidia-sata=y
CONFIG_PACKAGE_kmod-ata-pdc202xx-old=y
CONFIG_PACKAGE_kmod-ata-piix=y
CONFIG_PACKAGE_kmod-ata-sil=y
CONFIG_PACKAGE_kmod-ata-sil24=y
CONFIG_PACKAGE_kmod-ata-via-sata=y
CONFIG_PACKAGE_kmod-scsi-core=y
# 网络驱动
CONFIG_PACKAGE_kmod-3c59x=y
CONFIG_PACKAGE_kmod-8139cp=y
CONFIG_PACKAGE_kmod-8139too=y
CONFIG_PACKAGE_kmod-atl1=y
CONFIG_PACKAGE_kmod-atl1c=y
CONFIG_PACKAGE_kmod-atl1e=y
CONFIG_PACKAGE_kmod-atl2=y
CONFIG_PACKAGE_kmod-b44=y
CONFIG_PACKAGE_kmod-be2net=y
CONFIG_PACKAGE_kmod-bnx2=y
CONFIG_PACKAGE_kmod-dm9000=y
CONFIG_PACKAGE_kmod-dummy=y
CONFIG_PACKAGE_kmod-e100=y
CONFIG_PACKAGE_kmod-e1000=y
CONFIG_PACKAGE_kmod-e1000e=y
CONFIG_PACKAGE_kmod-et131x=y
CONFIG_PACKAGE_kmod-ethoc=y
CONFIG_PACKAGE_kmod-forcedeth=y
CONFIG_PACKAGE_kmod-gigaset=y
CONFIG_PACKAGE_kmod-hfcmulti=y
CONFIG_PACKAGE_kmod-hfcpci=y
CONFIG_PACKAGE_kmod-ifb=y
CONFIG_PACKAGE_kmod-igb=y
CONFIG_PACKAGE_kmod-igbvf=y
CONFIG_PACKAGE_kmod-ixgbe=y
CONFIG_PACKAGE_kmod-ixgbevf=y
CONFIG_PACKAGE_kmod-libphy=y
CONFIG_PACKAGE_kmod-macvlan=y
CONFIG_PACKAGE_kmod-mdio-gpio=y
CONFIG_PACKAGE_kmod-mii=y
CONFIG_PACKAGE_kmod-natsemi=y
CONFIG_PACKAGE_kmod-ne2k-pci=y
CONFIG_PACKAGE_kmod-niu=y
CONFIG_PACKAGE_kmod-of-mdio=y
CONFIG_PACKAGE_kmod-pcnet32=y
CONFIG_PACKAGE_kmod-phy-broadcom=y
CONFIG_PACKAGE_kmod-phy-realtek=y
CONFIG_PACKAGE_kmod-phylib-broadcom=y
CONFIG_PACKAGE_kmod-r6040=y
CONFIG_PACKAGE_kmod-r8125=y
CONFIG_PACKAGE_kmod-r8169=y
CONFIG_PACKAGE_kmod-siit=y
CONFIG_PACKAGE_kmod-sis190=y
CONFIG_PACKAGE_kmod-sis900=y
CONFIG_PACKAGE_kmod-skge=y
CONFIG_PACKAGE_kmod-sky2=y
CONFIG_PACKAGE_kmod-solos-pci=y
CONFIG_PACKAGE_kmod-spi-ks8995=y
CONFIG_PACKAGE_kmod-swconfig=y
CONFIG_PACKAGE_kmod-switch-ip17xx=y
CONFIG_PACKAGE_kmod-switch-mvsw61xx=y
CONFIG_PACKAGE_kmod-switch-rtl8306=y
CONFIG_PACKAGE_kmod-switch-rtl8366-smi=y
CONFIG_PACKAGE_kmod-switch-rtl8366rb=y
CONFIG_PACKAGE_kmod-switch-rtl8366s=y
CONFIG_PACKAGE_kmod-switch-rtl8367b=y
CONFIG_PACKAGE_kmod-tg3=y
CONFIG_PACKAGE_kmod-tulip=y
CONFIG_PACKAGE_kmod-via-rhine=y
CONFIG_PACKAGE_kmod-via-velocity=y
CONFIG_PACKAGE_kmod-vmxnet3=y
# USB设备支持
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb-hid=y
CONFIG_PACKAGE_kmod-usb-net=y
CONFIG_PACKAGE_kmod-usb-net-asix=y
CONFIG_PACKAGE_kmod-usb-net-asix-ax88179=y
CONFIG_PACKAGE_kmod-usb-net-cdc-eem=y
CONFIG_PACKAGE_kmod-usb-net-cdc-ether=y
CONFIG_PACKAGE_kmod-usb-net-cdc-mbim=y
CONFIG_PACKAGE_kmod-usb-net-cdc-ncm=y
CONFIG_PACKAGE_kmod-usb-net-cdc-subset=y
CONFIG_PACKAGE_kmod-usb-net-dm9601-ether=y
CONFIG_PACKAGE_kmod-usb-net-hso=y
CONFIG_PACKAGE_kmod-usb-net-huawei-cdc-ncm=y
CONFIG_PACKAGE_kmod-usb-net-ipheth=y
CONFIG_PACKAGE_kmod-usb-net-kalmia=y
CONFIG_PACKAGE_kmod-usb-net-kaweth=y
CONFIG_PACKAGE_kmod-usb-net-mcs7830=y
CONFIG_PACKAGE_kmod-usb-net-pegasus=y
CONFIG_PACKAGE_kmod-usb-net-pl=y
CONFIG_PACKAGE_kmod-usb-net-qmi-wwan=y
CONFIG_PACKAGE_kmod-usb-net-rndis=y
CONFIG_PACKAGE_kmod-usb-net-rtl8150=y
CONFIG_PACKAGE_kmod-usb-net-rtl8152=y
CONFIG_PACKAGE_kmod-usb-net-sierrawireless=y
CONFIG_PACKAGE_kmod-usb-net-smsc95xx=y
CONFIG_PACKAGE_kmod-usb-net-sr9700=y
CONFIG_PACKAGE_kmod-usb-wdm=y
EOF

# 其他软件包:
cat >> .config <<EOF
CONFIG_HAS_FPU=y
CONFIG_PACKAGE_autocore=y
CONFIG_PACKAGE_kmod-zram=y
CONFIG_PACKAGE_zram-swap=y
# Crypto
CONFIG_PACKAGE_kmod-crypto-acompress=y
CONFIG_PACKAGE_kmod-crypto-aead=y
CONFIG_PACKAGE_kmod-crypto-authenc=y
CONFIG_PACKAGE_kmod-crypto-cbc=y
CONFIG_PACKAGE_kmod-crypto-crc32=y
CONFIG_PACKAGE_kmod-crypto-crc32c=y
CONFIG_PACKAGE_kmod-crypto-deflate=y
CONFIG_PACKAGE_kmod-crypto-des=y
CONFIG_PACKAGE_kmod-crypto-ecb=y
CONFIG_PACKAGE_kmod-crypto-echainiv=y
CONFIG_PACKAGE_kmod-crypto-gf128=y
CONFIG_PACKAGE_kmod-crypto-hash=y
CONFIG_PACKAGE_kmod-crypto-hmac=y
CONFIG_PACKAGE_kmod-crypto-iv=y
CONFIG_PACKAGE_kmod-crypto-manager=y
CONFIG_PACKAGE_kmod-crypto-md5=y
CONFIG_PACKAGE_kmod-crypto-misc=y
CONFIG_PACKAGE_kmod-crypto-null=y
CONFIG_PACKAGE_kmod-crypto-pcompress=y
CONFIG_PACKAGE_kmod-crypto-rng=y
CONFIG_PACKAGE_kmod-crypto-sha1=y
CONFIG_PACKAGE_kmod-crypto-sha256=y
CONFIG_PACKAGE_kmod-crypto-wq=y
CONFIG_PACKAGE_kmod-crypto-xts=y
# Python库
CONFIG_PACKAGE_python=y
CONFIG_PACKAGE_python-base=y
CONFIG_PACKAGE_python-codecs=y
CONFIG_PACKAGE_python-compiler=y
CONFIG_PACKAGE_python-ctypes=y
CONFIG_PACKAGE_python-db=y
CONFIG_PACKAGE_python-decimal=y
CONFIG_PACKAGE_python-distutils=y
CONFIG_PACKAGE_python-gdbm=y
CONFIG_PACKAGE_python-light=y
CONFIG_PACKAGE_python-logging=y
CONFIG_PACKAGE_python-ncurses=y
CONFIG_PACKAGE_python-openssl=y
CONFIG_PACKAGE_python-pydoc=y
CONFIG_PACKAGE_python-sqlite3=y
CONFIG_PACKAGE_python-unittest=y
CONFIG_PACKAGE_python-xml=y
# .
CONFIG_PACKAGE_luci-lib-json=y
CONFIG_PACKAGE_luci-lib-jsonc=y
CONFIG_PACKAGE_luci-mod-rpc=y
CONFIG_PACKAGE_cgi-io=y
CONFIG_PACKAGE_ddns-scripts_cloudflare.com-v4=y
CONFIG_PACKAGE_ddns-scripts_freedns_42_pl=y
CONFIG_PACKAGE_ddns-scripts_godaddy.com-v1=y
CONFIG_PACKAGE_ddns-scripts_no-ip_com=y
CONFIG_PACKAGE_ddns-scripts_route53-v1=y
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_kmod-ipsec=y
CONFIG_PACKAGE_kmod-ipsec4=y
CONFIG_PACKAGE_kmod-ipsec6=y
CONFIG_PACKAGE_kmod-ipt-extra=y
CONFIG_PACKAGE_kmod-ipt-ipsec=y
CONFIG_PACKAGE_kmod-ipt-ipset=y
CONFIG_PACKAGE_iptables-mod-ipsec=y
CONFIG_PACKAGE_kmod-isdn4linux=y
CONFIG_PACKAGE_kmod-mdio=y
CONFIG_PACKAGE_kmod-misdn=y
CONFIG_PACKAGE_kmod-gre=y
CONFIG_PACKAGE_kmod-iptunnel6=y
CONFIG_PACKAGE_kmod-lib-lz4=y
CONFIG_PACKAGE_kmod-lib-lzo=y
CONFIG_PACKAGE_kmod-lib-zlib-deflate=y
CONFIG_PACKAGE_kmod-lib-zlib-inflate=y
CONFIG_PACKAGE_kmod-macvlan=y
CONFIG_PACKAGE_kmod-mppe=y
CONFIG_PACKAGE_kmod-nft-core=y
CONFIG_PACKAGE_kmod-nft-netdev=y
CONFIG_PACKAGE_e100-firmware=y
CONFIG_PACKAGE_libbz2=y
CONFIG_PACKAGE_libdb47=y
CONFIG_PACKAGE_libexpat=y
CONFIG_PACKAGE_libfreetype=y
CONFIG_PACKAGE_libgdbm=y
CONFIG_PACKAGE_libminiupnpc=y
CONFIG_PACKAGE_libnatpmp=y
CONFIG_PACKAGE_libnftnl=y
CONFIG_PACKAGE_libvorbis=y
CONFIG_PACKAGE_nft-qos=y
CONFIG_PACKAGE_nftables=y
CONFIG_PACKAGE_zoneinfo-asia=y
CONFIG_PACKAGE_rpcd-mod-file=y
CONFIG_PACKAGE_rpcd-mod-iwinfo=y
EOF

# 
# ========================固件定制部分结束========================
# 

sed -i 's/^[ \t]*//g' ./.config

# 配置文件创建完成

