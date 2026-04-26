#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# 适配Phicomm K2P 32M闪存 - 修改DTS设备树
DTS_FILE="target/linux/ramips/dts/mt7621_phicomm_k2p.dts"
if [ -f "$DTS_FILE" ]; then
    # 修改闪存总大小为32M (0x2000000)
    sed -i 's/reg = <0x0 0x1000000>/reg = <0x0 0x2000000>/g' $DTS_FILE
    # 修改firmware分区大小，适配32M空间
    sed -i 's/reg = <0x50000 0xfb0000>/reg = <0x50000 0x1fb0000>/g' $DTS_FILE
    echo "32M闪存DTS适配完成"
fi

# 添加PassWall官方插件源
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default

# 可选：修改固件默认管理IP（默认192.168.1.1，如需修改取消下面注释）
# sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 可选：设置默认root密码（如需设置取消下面注释，替换yourpassword为你的密码）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# 移除冲突的dnsmasq，替换为dnsmasq-full（PassWall必需依赖）
sed -i 's/CONFIG_PACKAGE_dnsmasq=y/CONFIG_PACKAGE_dnsmasq=n/g' .config 2>/dev/null || true
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config

# 开启IPv6支持（可选，默认开启）
echo "CONFIG_PACKAGE_ipv6helper=y" >> .config
