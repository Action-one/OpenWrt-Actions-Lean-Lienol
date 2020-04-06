  
#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

# 替换默认Argon主题（最新版本适配有问题,暂取消）
# rm -rf package/lean/luci-theme-argon
# git clone https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon

# 添加第三方软件包
git clone https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone https://github.com/vernesong/OpenClash package/openclash
git clone https://github.com/tty228/luci-app-serverchan package/luci-app-serverchan
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome
git clone https://github.com/kang-mk/luci-app-smartinfo package/luci-app-smartinfo

# 自定义定制选项
sed -i 's#192.168.1.1#10.0.0.1#g' package/base-files/files/bin/config_generate #定制默认IP
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings #取消系统默认密码
sed -i 's@.*stats auth admin:root*@#&@g' package/lean/luci-app-haproxy-tcp/root/etc/haproxy_init.sh #取消haproxy默认密码
sed -i 's#frontend ss-in#frontend HAProxy-in#g' package/lean/luci-app-haproxy-tcp/root/etc/haproxy_init.sh #修改haproxy默认节点名称
sed -i 's#backend ss-out#backend HAProxy-out#g' package/lean/luci-app-haproxy-tcp/root/etc/haproxy_init.sh #修改haproxy默认节点名称
sed -i 's#option commit_interval 24h#option commit_interval 10m#g' feeds/packages/net/nlbwmon/files/nlbwmon.config #修改流量统计写入为10分钟
sed -i 's#option database_directory /var/lib/nlbwmon#option database_directory /etc/config/nlbwmon_data#g' feeds/packages/net/nlbwmon/files/nlbwmon.config #修改流量统计数据存放默认位置

#创建自定义配置文件 - OpenWrt-x86-64

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

# 编译UEFI固件:
cat >> .config <<EOF
CONFIG_EFI_IMAGES=y
EOF

# IPv6支持:
cat >> .config <<EOF
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
CONFIG_PACKAGE_ipv6helper=y
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
# CONFIG_PACKAGE_luci-app-openclash=y #OpenClash
CONFIG_PACKAGE_luci-app-serverchan=y #微信推送
# CONFIG_PACKAGE_luci-app-adguardhome=y #ADguardhome
# CONFIG_PACKAGE_luci-app-smartinfo=y #磁盘健康监控
EOF

# ShadowsocksR插件:
# cat >> .config <<EOF
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks=y
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Socks=y
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Server=y
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=y
# EOF

# 常用LuCI插件(禁用):
cat >> .config <<EOF
# CONFIG_PACKAGE_luci-app-transmission is not set #TR离线下载
# CONFIG_PACKAGE_luci-app-qbittorrent is not set #QB离线下载
# CONFIG_PACKAGE_luci-app-xlnetacc is not set #迅雷快鸟
# CONFIG_PACKAGE_luci-app-zerotier is not set #zerotier内网穿透
# CONFIG_PACKAGE_luci-app-hd-idle is not set #磁盘休眠
# CONFIG_PACKAGE_luci-app-wrtbwmon is not set #实时流量监测
# CONFIG_PACKAGE_luci-app-unblockmusic is not set #解锁网易云灰色歌曲
# CONFIG_PACKAGE_luci-app-airplay2 is not set #Apple AirPlay2音频接收服务器
# CONFIG_PACKAGE_luci-app-usb-printer is not set #USB打印机
# CONFIG_PACKAGE_luci-app-usb-cpufreq is not set #CPU频率设置
# CONFIG_PACKAGE_luci-app-usb-diskman is not set #磁盘分区管理
#
# VPN相关插件(禁用):
#
# CONFIG_PACKAGE_luci-app-v2ray-server is not set #V2ray服务器
# CONFIG_PACKAGE_luci-app-pptp-server is not set #PPTP VPN 服务器
# CONFIG_PACKAGE_luci-app-ipsec-vpnd is not set #ipsec VPN服务
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun is not set #Kcptun客户端
#
# 文件共享相关(禁用):
#
# CONFIG_PACKAGE_luci-app-minidlna is not set #miniDLNA服务
# CONFIG_PACKAGE_luci-app-vsftpd is not set #FTP 服务器
# CONFIG_PACKAGE_luci-app-samba is not set #网络共享
# CONFIG_PACKAGE_autosamba is not set #网络共享
# CONFIG_PACKAGE_samba36-server is not set #网络共享
EOF

# 常用LuCI插件(启用):
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-adbyby-plus=y #adbyby去广告
CONFIG_PACKAGE_luci-app-webadmin=y #Web管理页面设置
CONFIG_PACKAGE_luci-app-ddns=y #DDNS服务
CONFIG_DEFAULT_luci-app-vlmcsd=y #KMS激活服务器
CONFIG_PACKAGE_luci-app-filetransfer=y #系统-文件传输
CONFIG_PACKAGE_luci-app-autoreboot=y #定时重启
CONFIG_PACKAGE_luci-app-upnp=y #通用即插即用UPnP(端口自动转发)
CONFIG_PACKAGE_luci-app-accesscontrol=y #上网时间控制
CONFIG_PACKAGE_luci-app-wol=y #网络唤醒
CONFIG_PACKAGE_luci-app-sqm=y #SQM智能队列管理
CONFIG_PACKAGE_luci-app-flowoffload=y #Turbo ACC 网络加速
CONFIG_PACKAGE_luci-app-softethervpn=y #SoftEtherVPN服务器
CONFIG_PACKAGE_luci-app-haproxy-tcp=y #Haproxy负载均衡
CONFIG_PACKAGE_luci-app-frpc=y #Frp内网穿透
CONFIG_PACKAGE_luci-app-nlbwmon=y #宽带流量监控
EOF

# LuCI主题:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-theme-netgear=y
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
EOF

# 取消编译VMware镜像以及镜像填充 (不要删除被缩进的注释符号):
cat >> .config <<EOF
# CONFIG_TARGET_IMAGES_PAD is not set
# CONFIG_VMDK_IMAGES is not set
EOF

# 
# ========================固件定制部分结束========================
# 


sed -i 's/^[ \t]*//g' ./.config

# 配置文件创建完成
