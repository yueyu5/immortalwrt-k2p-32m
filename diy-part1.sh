#!/bin/bash

# ==============================================
# 【终极修复】Phicomm K2P 32M 闪存 + 根目录完整空间
# 编译后根目录直接 ~28MB 可用空间
# ==============================================

# 1. 修复 DTS 32M 闪存 + 完整固件分区（关键！）
DTS_FILE="target/linux/ramips/dts/mt7621_phicomm_k2p.dts"
if [ -f "$DTS_FILE" ]; then
    echo "✅ 开始修改 K2P 32M 闪存 DTS 分区表"
    
    # 闪存总大小 32M
    sed -i 's/reg = <0x0 0x1000000>/reg = <0x0 0x2000000>/g' $DTS_FILE
    
    # 🔥 核心修复：把固件分区扩大到 32M 全部空间（根目录直接用满）
    sed -i 's/0x50000 0xfb0000/0x50000 0x1fb0000/g' $DTS_FILE
    
    # 删除残留的空闲分区（避免出现未挂载分区）
    sed -i '/partition@1800000/,+5d' $DTS_FILE 2>/dev/null
    sed -i '/label = "unused"/,+4d' $DTS_FILE 2>/dev/null
    
    echo "✅ K2P 32M 完整分区修改完成"
fi

# 2. 添加 PassWall 插件源
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default

# 3. 强制启用固件最大化空间（SquashFS 自动占满分区）
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=300" >> .config  # 根分区 300MB（自动适配闪存）
echo "CONFIG_TARGET_HOME_DIRECTORY=y" >> .config

# 4. PassWall 依赖：替换 dnsmasq 为 dnsmasq-full
sed -i 's/CONFIG_PACKAGE_dnsmasq=y/CONFIG_PACKAGE_dnsmasq=n/g' .config 2>/dev/null
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config

# 5. 开启 IPv6
echo "CONFIG_PACKAGE_ipv6helper=y" >> .config
