#!/bin/bash
# ==============================================
# Phicomm K2P 32M 闪存适配 + SSR-Plus 集成
# ==============================================

# 1. 核心修复：32M 闪存分区表（根目录直接占满完整空间）
DTS_FILE="target/linux/ramips/dts/mt7621_phicomm_k2p.dts"
if [ -f "$DTS_FILE" ]; then
    echo "✅ 适配 K2P 32M 闪存分区"
    # 闪存总大小改为 32M
    sed -i 's/reg = <0x0 0x1000000>/reg = <0x0 0x2000000>/g' $DTS_FILE
    # 固件分区拉满 32M 可用空间
    sed -i 's/0x50000 0xfb0000/0x50000 0x1fb0000/g' $DTS_FILE
    # 删除残留闲置分区
    sed -i '/partition@1800000/,+5d' $DTS_FILE 2>/dev/null
    sed -i '/label = "unused"/,+4d' $DTS_FILE 2>/dev/null
fi

# 2. 添加 SSR-Plus 官方稳定源（适配 ImmortalWrt 23.05）
echo "src-git helloworld https://github.com/fw876/helloworld.git;master" >> feeds.conf.default

# 3. 强制替换 dnsmasq 为 full 版本（SSR-Plus 必需依赖）
sed -i 's/CONFIG_PACKAGE_dnsmasq=y/CONFIG_PACKAGE_dnsmasq=n/g' .config 2>/dev/null
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config

# 4. 根分区大小适配 32M 闪存
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=250" >> .config

# 5. 开启 IPv6 支持
echo "CONFIG_PACKAGE_ipv6helper=y" >> .config

# 解除 K2P 原厂16M固件大小限制
sed -i '/IMAGE_SIZE := 16121856/d' target/linux/ramips/image/mt7621.mk
